output "iam_role_arn" {
  value = "${aws_iam_role.deployer_role.arn}"
}

output "iam_role_name" {
  value = "${aws_iam_role.deployer_role.name}"
}

output "iam_policy_arn" {
  value = "${aws_iam_policy.deployer_policy.arn}"
}

output "iam_policy_name" {
  value = "${aws_iam_policy.deployer_policy.name}"
}

output "iam_policy_id" {
  value = "${aws_iam_policy.deployer_policy.id}"
}
