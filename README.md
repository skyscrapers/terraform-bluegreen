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
  autoscaling_group_name = "my_asg_name"
}
```
