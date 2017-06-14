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

## cpu-scaling
Terraform module to setup alarms and autoscaling triggers for autoscaling

### Variables

See the [cpu-scaling/variables.tf](cpu-scaling/variables.tf) file.

### Outputs
/

### Example

```
module "cpu-scaling" {
  source = "github.com/skyscrapers/terraform-bluegreen//cpu-scaling"
  project = "example"
  name = "app"
  environment = "production"
  autoscaling_group_name = ["my_asg_name1","my_asg_name2"]
}
```

## Blue-green deployments
The blue-green deployment script expects certain inputs and outputs in the Terraform project you want to deploy in a blue-green fashion.
### Required outputs:
```
output "blue_asg_id" {
  value = "${module.<blue-green-module-name>.blue_asg_id}"
}

output "blue_asg_id" {
  value =  "${module.<blue-green-module-name>.blue_asg_id}"
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

These input variables need to be assigned to your module. Make sure you do a terraform refresh to be sure that the terraform outputs are saved in the Terraform state file. After that you can execute the blue-green script.
```
./bluegreen.py -f stacks/test/application -a ami-xxxx -c apply -t 500
```
