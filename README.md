# terraform-bluegreen
Terraform module to setup blue / green deployments

## blue-green

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| associate\_public\_ip\_address | (Optional) Associate a public ip address with an instance in a VPC | string | `"false"` | no |
| blue\_ami | (Required) The EC2 image ID to launch in the blue autoscaling group | string | n/a | yes |
| blue\_desired\_capacity | (Required) The number of Amazon EC2 instances that should be running in the blue autoscaling roup | string | n/a | yes |
| blue\_max\_size | (Required) The maximum size of the blue autoscaling group | string | n/a | yes |
| blue\_min\_size | (Required) The minimum size of the blue autoscaling group | string | n/a | yes |
| disk\_volume\_size | (Optional) The size of the volume in gigabytes | string | `"8"` | no |
| disk\_volume\_type | (Optional) The type of the volume. Default is standard | string | `"standard"` | no |
| environment | Environment to deploy on | string | n/a | yes |
| green\_ami | (Required) The EC2 image ID to launch in the green autoscaling group | string | n/a | yes |
| green\_desired\_capacity | (Required) The number of Amazon EC2 instances that should be running in the green autoscaling roup | string | n/a | yes |
| green\_max\_size | (Required) The maximum size of the green autoscaling group | string | n/a | yes |
| green\_min\_size | (Required) The minimum size of the green autoscaling group | string | n/a | yes |
| health\_check\_grace\_period | (Optional, Default: 300) Time (in seconds) after instance comes into service before checking health | string | `"300"` | no |
| health\_check\_type | The health check type to apply to the Autoscaling groups. | string | `"ELB"` | no |
| iam\_instance\_profile | (Optional) The IAM instance profile to associate with launched instances | string | `""` | no |
| instance\_type | (Required) The size of instance to launch | string | n/a | yes |
| key\_name | (Optional) The key name that should be used for the instance | string | `""` | no |
| loadbalancers | (Optional) A list of load balancer names to add to the autoscaling groups | list | `<list>` | no |
| name | Name of the stack | string | n/a | yes |
| project | Project name to use | string | n/a | yes |
| security\_groups | (Optional) A list of associated security group IDS | list | `<list>` | no |
| spot\_price | Spot price you want to pay for your instances. By default this is empty and we will use on-demand instances | string | `""` | no |
| subnets | (Optional) A list of subnet IDs to launch resources in | list | `<list>` | no |
| tags | (Optional, Default: []) List of map of additional tags | list | `<list>` | no |
| target\_group\_arns | A list of aws_alb_target_group ARNs, for use with Application Load Balancing | list | `<list>` | no |
| termination\_policies | (Optional, Default: ['Default']) Order in termination policies to apply when choosing instances to terminate. | list | `<list>` | no |
| user\_data | (Optional) The user data to provide when launching the instance | string | `"# Hello World"` | no |
| wait\_for\_capacity\_timeout | A maximum duration that Terraform should wait for ASG instances to be healthy before timing out. Setting this to 0 causes Terraform to skip all Capacity Waiting behavior. | string | `"10m"` | no |

### Outputs

| Name | Description |
|------|-------------|
| blue\_asg\_id | Blue autoscaling group id |
| green\_asg\_id | Green autoscaling group id |

### Example

```terraform
module "bluegreen" {
  source = "github.com/skyscrapers/terraform-bluegreen//blue-green"
  project = "example"
  name = "app"
  environment = "production"
  blue_ami = "ami-blabla"
  green_ami = "ami-blabla"
  instance_type = "t2.micro"
  loadbalancers = []
  blue_max_size = "5"
  blue_min_size = "2"
  blue_desired_capacity = "2"
  green_max_size = "0"
  green_min_size = "0"
  green_desired_capacity = "0"
  security_groups = []
}
```

## scaling

Terraform module to setup alarms and autoscaling triggers for autoscaling

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| adjustment\_down | The number of instances to remove when the alarm is triggered (the value has to be negative) | string | `"-1"` | no |
| adjustment\_type | What typ of adjustment needs to happen | string | `"ChangeInCapacity"` | no |
| adjustment\_up | The number of instances to add when the alarm is triggered | string | `"1"` | no |
| autoscaling\_group\_name | The name of the AS group this config needs to be applied | list | n/a | yes |
| cooldown\_down | The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start. | string | `"600"` | no |
| cooldown\_up | The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start. | string | `"300"` | no |
| dimension\_name |  | string | `"AutoScalingGroupName"` | no |
| dimension\_value |  | string | `"false"` | no |
| environment | Environment to deploy on | string | n/a | yes |
| evaluation\_periods | the number of samples to evaluate | string | `"4"` | no |
| metric\_name | The metric the scaling is based upon | string | `"CPUUtilization"` | no |
| name | Name of the stack | string | n/a | yes |
| namespace | the namespace of the cloudwatch metric | string | `"AWS/EC2"` | no |
| num\_asg | the number of autoscaling groups passed | string | `"2"` | no |
| period\_down | he period in seconds over which the selected metric statistic is applied. | string | `"120"` | no |
| period\_up | he period in seconds over which the selected metric statistic is applied. | string | `"60"` | no |
| policy\_type | The policy type, either SimpleScaling or StepScaling | string | `"SimpleScaling"` | no |
| project | Project name to use | string | n/a | yes |
| statistic | The statistic to apply to the alarm's associated metric. Either of the following is supported: | string | `"Average"` | no |
| threshold\_down | The metric value to scale down | string | `"30"` | no |
| threshold\_up | The metric value to scale up | string | `"80"` | no |

### Example

```terraform
module "scaling" {
  source = "github.com/skyscrapers/terraform-bluegreen//scaling"
  project = "example"
  name = "app"
  environment = "production"
  autoscaling_group_name = ["my_asg_name1","my_asg_name2"]
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
