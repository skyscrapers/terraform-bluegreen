# terraform-bluegreen
Terraform module to setup blue / green deployments

### Variables

* `project`:
* `name`:
* `environment`:
* `blue_ami`:
* `green_ami`:
* `instance_type`:
* `key_name`:
* `blue_loadbalancers`:
* `green_loadbalancers`:
* `security_groups`:
* `iam_instance_profile`:
* `associate_public_ip_address`:
* `user_data`:
* `disk_volume_size`:
* `disk_volume_type`:
* `availability_zones`:
* `subnets`:
* `blue_max_size`:
* `blue_min_size`:
* `blue_desired_capacity`:
* `green_max_size`:
* `green_min_size`:
* `green_desired_capacity`:
* `health_check_grace_period`:

### Outputs

* `blue_asg`: (object) blue autoscaling group
* `green_asg`: (object) green autoscaling group

### Example

```
module "bluegreen" {
  source = "github.com/skyscrapers/terraform-bluegreen//blue-green"
  project = "example"
  name = "app"
  environment = "production"
  blue_ami = "ami-blabla"
  green_ami = "ami-blabla"
  blue_loadbalancers = []
  green_loadbalancers = []
  blue_max_size = "5"
  blue_min_size = "2"
  blue_desired_capacity = "2"
  green_max_size = "0"
  green_min_size = "0"
  green_desired_capacity = "0"
  security_groups = []
}
```
