resource "aws_iam_role" "deployer_role" {
  name_prefix        = "deployer_${var.project}_${var.environment}_"
  path               = "/bluegreen"
  assume_role_policy = "${data.aws_iam_policy_document.deployer_assume_role_policy.json}"
}

data "aws_iam_policy_document" "deployer_assume_role_policy" {
  statement {
    sid     = "1"
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["${var.principals_aws}"]
    }
  }
}

resource "aws_iam_role_policy" "deployer_policy" {
  name_prefix = "deployer_${var.project}_${var.environment}_"
  description = "Policy to allow blue-green deployments in this account"
  role        = "${aws_iam_role.deployer_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "TBD"
      ],
      "Effect": "Allow",
      "Resource": "TBD"
    }
  ]
}
EOF
}
