# terraform-bluegreen

Terraform module to setup blue / green deployments

## blue-green

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| associate\_public\_ip\_address | Associate a public ip address with an instance in a VPC | bool | `false` | no |
| blue\_ami | The EC2 image ID to launch in the Blue autoscaling group | string | n/a | yes |
| blue\_desired\_capacity | The number of Amazon EC2 instances that should be running in the blue autoscaling roup | number | n/a | yes |
| blue\_disk\_volume\_size | The size of the EBS volume in GB for the Blue instances | number | `8` | no |
| blue\_disk\_volume\_type | The EBS volume type for the Blue instances | string | `"gp2"` | no |
| blue\_instance\_type | The Blue instance type to launch | string | n/a | yes |
| blue\_max\_size | The maximum size of the blue autoscaling group | number | n/a | yes |
| blue\_min\_size | The minimum size of the blue autoscaling group | number | n/a | yes |
| blue\_user\_data | The user data to provide when launching the Blue instances | string | `"# Hello World"` | no |
| green\_ami | The EC2 image ID to launch in the Green autoscaling group | string | n/a | yes |
| green\_desired\_capacity | The number of Amazon EC2 instances that should be running in the green autoscaling roup | number | n/a | yes |
| green\_disk\_volume\_size | The size of the EBS volume in GB for the Green instances | number | `8` | no |
| green\_disk\_volume\_type | The EBS volume type for the Green instances | string | `"gp2"` | no |
| green\_instance\_type | The Green instance type to launch | string | n/a | yes |
| green\_max\_size | The maximum size of the green autoscaling group | number | n/a | yes |
| green\_min\_size | The minimum size of the green autoscaling group | number | n/a | yes |
| green\_user\_data | The user data to provide when launching the Green instances | string | `"# Hello World"` | no |
| health\_check\_grace\_period | Time (in seconds) after instance comes into service before checking health | number | `300` | no |
| health\_check\_type | The health check type to apply to the Autoscaling groups. | string | `"ELB"` | no |
| iam\_instance\_profile | The IAM instance profile to associate with launched instances | string | `""` | no |
| initial\_lifecycle\_hooks | One or more [Lifecycle Hooks](http://docs.aws.amazon.com/autoscaling/latest/userguide/lifecycle-hooks.html) to attach to the autoscaling group before instances are launched. The syntax is exactly the same as the separate [`aws_autoscaling_lifecycle_hook`](https://www.terraform.io/docs/providers/aws/r/autoscaling_lifecycle_hooks.html) resource, without the autoscaling_group_name attribute | list(map(string)) | `[]` | no |
| key\_name | The key name that should be used for the instance | string | `""` | no |
| loadbalancers | A list of load balancer names to add to the autoscaling groups | list(string) | `[]` | no |
| name | Name of the Auto Scaling Groups | string | n/a | yes |
| security\_groups | A list of associated security group IDS | list(string) | `[]` | no |
| spot\_price | Spot price you want to pay for your instances. By default this is empty and we will use on-demand instances | string | `""` | no |
| subnets | A list of subnet IDs to launch resources in | list(string) | `[]` | no |
| tags | List as a map of additional tags | list(map(string)) | `[]` | no |
| target\_group\_arns | A list of aws_alb_target_group ARNs, for use with Application Load Balancing | list(string) | `[]` | no |
| termination\_policies | Order in termination policies to apply when choosing instances to terminate. | list(string) | `[]` | no |
| wait\_for\_capacity\_timeout | A maximum duration that Terraform should wait for ASG instances to be healthy before timing out. Setting this to 0 causes Terraform to skip all Capacity Waiting behavior. | string | `"10m"` | no |

### Outputs

| Name | Description |
|------|-------------|
| blue\_asg\_id | Blue autoscaling group id |
| green\_asg\_id | Green autoscaling group id |
| nonbinding\_blue\_asg\_name | This is the raw blue autoscaling group name, without creating a dependency with the actual autoscaling group resource |
| nonbinding\_green\_asg\_name | This is the raw green autoscaling group name, without creating a dependency with the actual autoscaling group resource |

### Example

```terraform
module "bluegreen" {
  source                 = "github.com/skyscrapers/terraform-bluegreen//blue-green"
  name                   = "app-${terraform.workspace}"
  blue_ami               = "ami-blabla"
  blue_instance_type     = "t3.micro"
  blue_max_size          = 5
  blue_min_size          = 2
  blue_desired_capacity  = 2
  green_ami              = "ami-blabla"
  green_instance_type    = "t3.micro"
  green_max_size         = 0
  green_min_size         = 0
  green_desired_capacity = 0
  loadbalancers          = ["myloadbalancers"]
  security_groups        = ["mysecuritygroups"]
}
```

## scaling

Terraform module to setup alarms and autoscaling triggers for autoscaling

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| adjustment\_down | The number of instances to remove when the alarm is triggered (the value has to be negative) | number | `-1` | no |
| adjustment\_type | What typ of adjustment needs to happen | string | `"ChangeInCapacity"` | no |
| adjustment\_up | The number of instances to add when the alarm is triggered | number | `1` | no |
| autoscaling\_group\_names | The names of the Auto Scaling Groups this config needs to be applied to | list | n/a | yes |
| cooldown\_down | The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start. | number | `600` | no |
| cooldown\_up | The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start. | number | `300` | no |
| dimension\_name |  | string | `"AutoScalingGroupName"` | no |
| dimension\_value |  | bool | `false` | no |
| evaluation\_periods | The number of samples to evaluate | number | `4` | no |
| metric\_name | The metric the scaling is based upon | string | `"CPUUtilization"` | no |
| name | Name of the Auto Scaling Groups | string | n/a | yes |
| namespace | The namespace of the cloudwatch metric | string | `"AWS/EC2"` | no |
| num\_asg | The number of autoscaling groups passed | number | `2` | no |
| period\_down | The period in seconds over which the selected metric statistic is applied. | number | `120` | no |
| period\_up | The period in seconds over which the selected metric statistic is applied. | number | `60` | no |
| policy\_type | The policy type, either SimpleScaling or StepScaling | string | `"SimpleScaling"` | no |
| statistic | The statistic to apply to the alarm's associated metric. Either of the following is supported: | string | `"Average"` | no |
| threshold\_down | The metric value to scale down | number | `30` | no |
| threshold\_up | The metric value to scale up | number | `80` | no |

### Example

```terraform
module "scaling" {
  source                  = "github.com/skyscrapers/terraform-bluegreen//scaling"
  name                    = "app-${terraform.workspace}"
  autoscaling_group_names = ["my_asg_name1","my_asg_name2"]
}
```

## Blue-green deployments

The `bluegreen.py` script performs a bluegreen deployment of the selected terraform stack. It only works with Python 2.7.
The blue-green deployment script expects certain inputs and outputs in the Terraform project you want to deploy in a blue-green fashion.

### Required outputs

```terraform
output "blue_asg_id" {
  value = "${module.<blue-green-module-name>.blue_asg_id}"
}

output "green_asg_id" {
  value = "${module.<blue-green-module-name>.green_asg_id}"
}
```

### Required variables

```terraform
variable "blue_max_size" {
  description = "max instances blue"
}

variable "blue_min_size" {
  description = "min instances blue"
}

variable "blue_desired_capacity" {
  description = "desired instances blue"
}

variable "green_max_size" {
  description = "max instances green"
}

variable "green_min_size" {
  description = "min instances green"
}

variable "green_desired_capacity" {
  description = "desired instances green"
}

variable "blue_ami" {
  description = "blue ami"
}

variable "green_ami" {
  description = "green ami"
}
```

These input variables need to be assigned to your module. Make sure you do a terraform refresh to be sure that the terraform outputs are saved in the Terraform state file.

### Usage

First you need to install the requirements:

```sh
pip install -r requirements.txt
```

Run `./bluegreen.py --help` to see the available options.

Example:

```sh
./bluegreen.py -f stacks/test/application -a ami-xxxx -c apply -t 500
```
