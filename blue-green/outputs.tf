output "blue_asg_id" {
  description = "Blue autoscaling group id"
  value       = "${module.blue.asg_id}"
}

output "green_asg_id" {
  description = "Green autoscaling group id"
  value       = "${module.green.asg_id}"
}

output "nonbinding_blue_asg_name" {
  description = "This is the raw blue autoscaling group name, without creating a dependency with the actual autoscaling group resource"
  value       = "${module.blue.nonbinding_asg_name}"
}

output "nonbinding_green_asg_name" {
  description = "This is the raw green autoscaling group name, without creating a dependency with the actual autoscaling group resource"
  value       = "${module.green.nonbinding_asg_name}"
}
