# terraform-bluegreen
Terraform module to setup blue / green deployments

##blue-green

### Variables

See the [blue-green/variables.tf](blue-green/variables.tf) file.

### Outputs

* `blue_asg_id`: (Number) blue autoscaling group id
* `green_asg_id`: (Number) green autoscaling group id

### Example

```
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

### Variables

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

### Outputs
/

### Example

```
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

### Required outputs:
```
output "blue_asg_id" {
  value = "${module.<blue-green-module-name>.blue_asg_id}"
}

output "green_asg_id" {
  value = "${module.<blue-green-module-name>.green_asg_id}"
}
```
### Required variables:
```
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
