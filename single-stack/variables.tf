variable "color" {
  description = ""
}
variable "project" {
  description = "Project name to use"
}
variable "name" {
  description = "Name of the stack"
}
variable "environment" {
  description = "Environment to deploy on"
}
variable "ami" {
  description = "(Required) The EC2 image ID to launch"
}
variable "instance_type" {
  description = "(Required) The size of instance to launch"
}
variable "key_name" {
  description = "(Optional) The key name that should be used for the instance"
  default = ""
}
variable "loadbalancers" {
  type = "list"
  description = "List of the loadbalancer ids to attach to the autoscaling groups"
  default = []
}
variable "security_groups" {
  type = "list"
  description = "(Optional) A list of associated security group IDS"
  default = []
}
variable "iam_instance_profile" {
  description = "(Optional) The IAM instance profile to associate with launched instances"
  default = ""
}
variable "associate_public_ip_address" {
  description = "(Optional) Associate a public ip address with an instance in a VPC"
  default = false
}
variable "user_data" {
  description = "(Optional) The user data to provide when launching the instance"
  default = ""
}
variable "disksize" {
  description = "(Optional) The size of the volume in gigabytes"
  default = "8"
}
variable "availability_zones" { # TODO
  type = "list"
  description = "(Optional) A list of AZs to launch resources in. Required only if you do not specify any vpc_zone_identifier"
  default = []
}
variable "subnets" {
  description = "(Optional) A list of subnet IDs to launch resources in"
  type = "list"
  default = []
}
variable "max_size" {
  description = ""
  default = 0
}
variable "min_size" {
  description = ""
  default = 0
}
variable "desired_capacity" {
  description = ""
  default = 0
}
variable "health_check_grace_period" {
  description = "(Optional, Default: 300) Time (in seconds) after instance comes into service before checking health"
  default = "300"
}
