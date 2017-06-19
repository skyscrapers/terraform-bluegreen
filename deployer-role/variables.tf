variable "environment" {
  description = "Environment to deploy on"
}

variable "project" {
  description = "Project name to use"
}

variable "principals_aws" {
  description = "List of ARNs of the IAM users or roles that can assume this role. Should be something like this: arn:aws:iam::AWS-account-ID:role/my_role"
  default     = []
}
