#!/usr/bin/env python

import boto3
import getopt
import sys
import subprocess
import time
from datetime import datetime


def main(argv):
    helptext = 'bluegreen.py -f <path to terraform project> -a <ami> -c <command> -t <timeout> -e <environment.tfvars path>'

    try:
        opts, args = getopt.getopt(argv, "hf:a:c:t:e:", ["folder=", "ami=", "command=", "timeout=", "environment="])
    except getopt.GetoptError:
        print helptext
        sys.exit(2)

    if opts:
        for opt, arg in opts:
            if opt == '-h':
                print helptext
                sys.exit(2)
            elif opt in ("-f", "--folder"):
                projectPath = arg
            elif opt in ("-a", "--ami"):
                ami = arg
            elif opt in ("-c", "--command"):
                command = arg
            elif opt in ("-t", "--timeout"):
                maxTimeout = int(arg)
            elif opt in ("-e", "--environment"):
                environment = arg
    else:
        print helptext
        sys.exit(2)

    if 'command' not in locals():
        command = 'plan'

    if 'maxTimeout' not in locals():
        maxTimeout = 200

    if 'projectPath' not in locals():
        print 'Please give your folder path of your Terraform project'
        print helptext
        sys.exit(2)

    if 'ami' not in locals():
        print 'Please give a new AMI as argument'
        print helptext
        sys.exit(2)

    if 'environment' not in locals():
        environment = None

    # Create a global variable to handle deploys on inactive autoscaling groups
    global inactiveAutoscalinggroups
    inactiveAutoscalinggroups = False

    # Retrieve autoscaling group names
    agBlue = getTerraformOutput(projectPath, 'blue_asg_id')
    agGreen = getTerraformOutput(projectPath, 'green_asg_id')

    # Retrieve autoscaling groups information
    info = getAutoscalingInfo(agBlue, agGreen)

    # Determine the active autoscaling group
    active = getActive(info)

    # Bring up the not active autoscaling group with the new AMI
    desiredInstanceCount = newAutoscaling(info, active, ami, command, projectPath, environment)

    # Retieve all ELBs and ALBs
    elbs = getLoadbalancers(info, 'elb')
    albs = getLoadbalancers(info, 'alb')

    # Retrieve autoscaling groups information (we need to do this again because the launchconig has changed and we need this in a later phase)
    info = getAutoscalingInfo(agBlue, agGreen)

    if command == 'apply':
        print 'Waiting for 30 seconds to get autoscaling status'
        time.sleep(30)
        timeout = 30
        while checkScalingStatus(elbs, albs, desiredInstanceCount) is not True:
            if timeout > maxTimeout:
                print 'Roling back'
                rollbackAutoscaling(info, active, ami, command, projectPath, environment)
                sys.exit(2)

            print 'Waiting for 10 seconds to get autoscaling status'
            time.sleep(10)
            timeout += 10

        print 'We can stop the old autoscaling now'
        oldAutoscaling(info, active, ami, command, projectPath, environment)
        if inactiveAutoscalinggroups:
            print 'Deactivating the autoscaling'


def getTerraformOutput(projectPath, output):
    process = subprocess.Popen('terraform output ' + output, shell=True, cwd=projectPath, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    std_out, std_err = process.communicate()
    if process.returncode != 0:
        err_msg = "%s. Code: %s" % (std_err.strip(), process.returncode)
        print err_msg
        sys.exit(process.returncode)

    return std_out.rstrip()


def getAutoscalingInfo(blue, green):
    client = boto3.client('autoscaling')
    response = client.describe_auto_scaling_groups(
        AutoScalingGroupNames=[
            blue,
            green,
        ],
        MaxRecords=2
    )
    return response


def getLoadbalancers(info, type):
    if type == 'alb':
        return info['AutoScalingGroups'][0]['TargetGroupARNs']
    else:
        return info['AutoScalingGroups'][0]['LoadBalancerNames']


def getAmi(launchconfig):
    client = boto3.client('autoscaling')
    response = client.describe_launch_configurations(
        LaunchConfigurationNames=[
            launchconfig,
        ],
        MaxRecords=1
    )
    return response['LaunchConfigurations'][0]['ImageId']


def getLaunchconfigDate(launchconfig):
    client = boto3.client('autoscaling')
    response = client.describe_launch_configurations(
        LaunchConfigurationNames=[
            launchconfig,
        ],
        MaxRecords=1
    )
    return datetime.strptime(response['LaunchConfigurations'][0]['CreatedTime'], '%Y-%m-%dT%H:%M:%S.%fZ')


def getActive(info):
    if info['AutoScalingGroups'][0]['DesiredCapacity'] > 0 and info['AutoScalingGroups'][1]['DesiredCapacity'] == 0:
        print 'Blue is active'
        return 0
    elif info['AutoScalingGroups'][0]['DesiredCapacity'] == 0 and info['AutoScalingGroups'][1]['DesiredCapacity'] > 0:
        print 'Green is active'
        return 1
    elif info['AutoScalingGroups'][0]['DesiredCapacity'] == 0 and info['AutoScalingGroups'][1]['DesiredCapacity'] == 0:
        print 'Both are inactive'
        global inactiveAutoscalinggroups
        inactiveAutoscalinggroups = True

        blueDate = getLaunchconfigDate(info['AutoScalingGroups'][0]['LaunchConfigurationName'])
        greenDate = getLaunchconfigDate(info['AutoScalingGroups'][1]['LaunchConfigurationName'])
        # use the ASG with the oldest launch config
        if blueDate < greenDate:
            print 'Blue has oldest launchconfig'
            return 1
        else:
            print 'Green has oldest launchconfig'
            return 0
    else:
        print 'Both are active'
        sys.exit(1)


def newAutoscaling(info, active, ami, command, projectPath, environment):
    blueMin = info['AutoScalingGroups'][active]['MinSize']
    blueMax = info['AutoScalingGroups'][active]['MaxSize']
    blueDesired = info['AutoScalingGroups'][active]['DesiredCapacity']

    greenMin = info['AutoScalingGroups'][active]['MinSize']
    greenMax = info['AutoScalingGroups'][active]['MaxSize']
    greenDesired = info['AutoScalingGroups'][active]['DesiredCapacity']

    if active == 0:
        blueAMI = getAmi(info['AutoScalingGroups'][active]['LaunchConfigurationName'])
        greenAMI = ami
        if inactiveAutoscalinggroups:  # if we are dealing with empty asgs we override the desired capacity
            greenDesired = 1
    elif active == 1:
        blueAMI = ami
        greenAMI = getAmi(info['AutoScalingGroups'][active]['LaunchConfigurationName'])
        if inactiveAutoscalinggroups:  # if we are dealing with empty asgs we override the desired capacity
            blueDesired = 1
    else:
        print 'No acive AMI'
        sys.exit(1)

    updateAutoscaling(command, blueMax, blueMin, blueDesired, blueAMI, greenMax, greenMin, greenDesired, greenAMI, projectPath, environment)

    # Return the amount of instances we should see in ELBs and ALBs. This is * 2 because we need to think about both autoscaling groups.
    # unless we are working with empty asgs
    if inactiveAutoscalinggroups:
        return 1
    else:
        return info['AutoScalingGroups'][active]['DesiredCapacity'] * 2


def oldAutoscaling(info, active, ami, command, projectPath, environment):
    blueAMI = getAmi(info['AutoScalingGroups'][0]['LaunchConfigurationName'])
    greenAMI = getAmi(info['AutoScalingGroups'][1]['LaunchConfigurationName'])
    if active == 0:
        blueMin = 0
        blueMax = 0
        blueDesired = 0

        greenMin = info['AutoScalingGroups'][active]['MinSize']
        greenMax = info['AutoScalingGroups'][active]['MaxSize']
        if inactiveAutoscalinggroups:
            greenDesired = 0
        else:
            greenDesired = info['AutoScalingGroups'][active]['DesiredCapacity']
    elif active == 1:
        blueMin = info['AutoScalingGroups'][active]['MinSize']
        blueMax = info['AutoScalingGroups'][active]['MaxSize']
        if inactiveAutoscalinggroups:
            blueDesired = 0
        else:
            blueDesired = info['AutoScalingGroups'][active]['DesiredCapacity']

        greenMin = 0
        greenMax = 0
        greenDesired = 0
    else:
        print 'No acive AMI'
        sys.exit(1)

    updateAutoscaling(command, blueMax, blueMin, blueDesired, blueAMI, greenMax, greenMin, greenDesired, greenAMI, projectPath, environment)


def rollbackAutoscaling(info, active, ami, command, projectPath, environment):
    blueAMI = getAmi(info['AutoScalingGroups'][0]['LaunchConfigurationName'])
    greenAMI = getAmi(info['AutoScalingGroups'][1]['LaunchConfigurationName'])

    if active == 0:
        blueMin = info['AutoScalingGroups'][0]['MinSize']
        blueMax = info['AutoScalingGroups'][0]['MaxSize']
        if inactiveAutoscalinggroups:
            blueDesired = 0
        else:
            blueDesired = info['AutoScalingGroups'][0]['DesiredCapacity']

        greenMin = 0
        greenMax = 0
        greenDesired = 0
    elif active == 1:
        greenMin = info['AutoScalingGroups'][1]['MinSize']
        greenMax = info['AutoScalingGroups'][1]['MaxSize']
        if inactiveAutoscalinggroups:
            greenDesired = 0
        else:
            greenDesired = info['AutoScalingGroups'][1]['DesiredCapacity']

        blueMin = 0
        blueMax = 0
        blueDesired = 0
    else:
        print 'No acive AMI'
        sys.exit(1)

    updateAutoscaling(command, blueMax, blueMin, blueDesired, blueAMI, greenMax, greenMin, greenDesired, greenAMI, projectPath, environment)


def stopAutoscaling(info, active, ami, command, projectPath, environment):
    blueMin = info['AutoScalingGroups'][active]['MinSize']
    blueMax = info['AutoScalingGroups'][active]['MaxSize']
    blueDesired = 0

    greenMin = info['AutoScalingGroups'][active]['MinSize']
    greenMax = info['AutoScalingGroups'][active]['MaxSize']
    greenDesired = 0

    if active == 0:
        blueAMI = getAmi(info['AutoScalingGroups'][active]['LaunchConfigurationName'])
        greenAMI = ami
    elif active == 1:
        blueAMI = ami
        greenAMI = getAmi(info['AutoScalingGroups'][active]['LaunchConfigurationName'])
    else:
        print 'No acive AMI'
        sys.exit(1)

    updateAutoscaling(command, blueMax, blueMin, blueDesired, blueAMI, greenMax, greenMin, greenDesired, greenAMI, projectPath, environment)


def updateAutoscaling(command, blueMax, blueMin, blueDesired, blueAMI, greenMax, greenMin, greenDesired, greenAMI, projectPath, environment):
    command = 'terraform %s %s' % (command, buildTerraformVars(blueMax, blueMin, blueDesired, blueAMI, greenMax, greenMin, greenDesired, greenAMI, environment))
    print command
    process = subprocess.Popen(command, shell=True, cwd=projectPath, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    out, err = process.communicate()
    print 'stdoutput'
    print out
    if process.returncode != 0:
        print 'stderror'
        print err
        sys.exit(process.returncode)


def checkScalingStatus(elbs, albs, desiredInstanceCount):
    client = boto3.client('elb')
    for elb in elbs:
        response = client.describe_instance_health(
            LoadBalancerName=elb
        )
        if desiredInstanceCount > len(response['InstanceStates']):
            print 'Not enough instances inside ELB, we expect ' + str(desiredInstanceCount) + ' and got ' + str(len(response['InstanceStates']))
            return False
        for state in response['InstanceStates']:
            print 'ELB: ' + state['State']
            if state['State'] != 'InService':
                return False
    client = boto3.client('elbv2')
    for alb in albs:
        response = client.describe_target_health(
            TargetGroupArn=alb,
        )
        if desiredInstanceCount > len(response['TargetHealthDescriptions']):
            print 'Not enough instances inside ALB, we expect ' + str(desiredInstanceCount) + ' and got ' + str(len(response['TargetHealthDescriptions']))
            return False
        for state in response['TargetHealthDescriptions']:
            print 'ALB: ' + state['TargetHealth']['State']
            if state['TargetHealth']['State'] != 'healthy':
                return False
    return True


def buildTerraformVars(blueMax, blueMin, blueDesired, blueAMI, greenMax, greenMin, greenDesired, greenAMI, environment):
    variables = {
        'blue_max_size': blueMax,
        'blue_min_size': blueMin,
        'blue_desired_capacity': blueDesired,
        'blue_ami': blueAMI,
        'green_max_size': greenMax,
        'green_min_size': greenMin,
        'green_desired_capacity': greenDesired,
        'green_ami': greenAMI
    }
    out = []

    # When using terraform environments, set the environment tfvars file
    if environment is not None:
        out.append('-var-file=%s' % (environment))

    for key, value in variables.iteritems():
        out.append('-var \'%s=%s\'' % (key, value))

    return ' '.join(out)


if __name__ == "__main__":
    main(sys.argv[1:])
