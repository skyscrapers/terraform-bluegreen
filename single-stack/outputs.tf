output "asg_id" {
  description = "ASG ID"
  value       = "${aws_autoscaling_group.bluegreen_asg.id}"
}

output "nonbinding_asg_name" {
  description = "This is the raw autoscaling group name, without creating a dependency with the actual autoscaling group resource"
  value       = "${local.asg_name}"
}
