output "blue_asg_id" {
  description = "Blue autoscaling group id"
  value       = "${module.blue.asg_id}"
}

output "green_asg_id" {
  description = "Green autoscaling group id"
  value       = "${module.green.asg_id}"
}

output "nondeterministic_blue_asg_name" {
  value = "${module.blue.nondeterministic_asg_name}"
}

output "nondeterministic_green_asg_name" {
  value = "${module.green.nondeterministic_asg_name}"
}
