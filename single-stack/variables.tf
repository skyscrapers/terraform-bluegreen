variable "color" {
  description = "Color of the Auto Scaling Group"
}

variable "name" {
  description = "Name of the Auto Scaling Group"
}

variable "ami" {
  description = "The EC2 image ID to launch"
}

variable "instance_type" {
  description = "The size of instance to launch"
}

variable "key_name" {
  description = "The key name that should be used for the instance"
  default     = ""
}

variable "loadbalancers" {
  type        = "list"
  description = "A list of load balancer names to add to the autoscaling group"
  default     = []
}

variable "security_groups" {
  type        = "list"
  description = "A list of associated security group IDS"
  default     = []
}

variable "iam_instance_profile" {
  description = "The IAM instance profile to associate with launched instances"
  default     = ""
}

variable "associate_public_ip_address" {
  description = "Associate a public ip address with an instance in a VPC"
  default     = false
}

variable "user_data" {
  description = "The user data to provide when launching the instance"
  default     = "# Hello World"
}

variable "disk_volume_size" {
  description = "The size of the volume in gigabytes"
  default     = "8"
}

variable "disk_volume_type" {
  description = "The type of the volume"
  default     = "gp2"
}

variable "subnets" {
  description = "A list of subnet IDs to launch resources in"
  type        = "list"
  default     = []
}

variable "max_size" {
  description = "The maximum size of the auto scale group"
}

variable "min_size" {
  description = "The minimum size of the auto scale group"
}

variable "desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the group"
}

variable "health_check_grace_period" {
  description = "Time (in seconds) after instance comes into service before checking health"
  default     = "300"
}

variable "termination_policies" {
  description = "Order in termination policies to apply when choosing instances to terminate. Always end with 'Default'."
  type        = "list"
  default     = ["Default"]
}

variable "target_group_arns" {
  type        = "list"
  description = "A list of aws_alb_target_group ARNs, for use with Application Load Balancing"
  default     = []
}

variable "health_check_type" {
  description = "The health check type to apply to the Autoscaling group."
  default     = "ELB"
}

variable "tags" {
  description = "List of map of additional tags"
  type        = "list"
  default     = []
}

variable "spot_price" {
  description = "Spot price you want to pay for your instances. By default this is empty and we will use on-demand instances"
  default     = ""
}

variable "wait_for_capacity_timeout" {
  description = "A maximum duration that Terraform should wait for ASG instances to be healthy before timing out. Setting this to 0 causes Terraform to skip all Capacity Waiting behavior."
  default     = "10m"
}

variable "initial_lifecycle_hooks" {
  description = "One or more [Lifecycle Hooks](http://docs.aws.amazon.com/autoscaling/latest/userguide/lifecycle-hooks.html) to attach to the autoscaling group before instances are launched. The syntax is exactly the same as the separate [`aws_autoscaling_lifecycle_hook`](https://www.terraform.io/docs/providers/aws/r/autoscaling_lifecycle_hooks.html) resource, without the autoscaling_group_name attribute"
  type        = "list"
  default     = []
}
