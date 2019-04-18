output "asg_id" {
  description = "ASG ID"
  value       = "${aws_autoscaling_group.bluegreen_asg.id}"
}

output "nondeterministic_asg_name" {
  value = "${local.asg_name}"
}
