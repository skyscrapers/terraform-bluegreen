variable "project" {
  description = ""
}
variable "name" {
  description = ""
}
variable "environment" {
  description = ""
}
variable "color" {
  description = ""
}
variable "ami" {
  description = ""
}
variable "instance_type" {
  description = ""
}
variable "key_name" {
  description = ""
}
variable "loadbalancers" {
  type = "list"
  description = ""
  default = []
}
variable "security_group" {
  description = ""
  default = ""
}
variable "iam_instance_profile" {
  description = ""
  default = ""
}
variable "associate_public_ip_address" {
  description = ""
  default = ""
}
variable "user_data" {
  description = ""
  default = ""
}
variable "disksize" {
  description = ""
  default = "8"
}
variable "availability_zones" {
  description = ""
  default = ""
}
variable "subnets" {
  description = ""
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
  description = ""
  default = "120"
}
