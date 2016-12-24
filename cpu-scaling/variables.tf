variable "evaluation_periods" {
  default = "4"
  description = "the number of samples to evaluate"
}
variable "namespace" {
  default = "AWS/EC2"
  description = "the namespace of the cpu cloudwatch metric"
}
variable "period_down" {
  default = "120"
  description = "he period in seconds over which the CPUUtilization statistic is applied."
}
variable "period_up" {
  default = "60"
  description = "he period in seconds over which the CPUUtilization statistic is applied."
}
variable "statistic" {
  default = "Average"
  description = "The statistic to apply to the alarm's associated metric. Either of the following is supported:"
}

variable "threshold_up" {
  default = "80"
  description = "The cpu value to scale up"
}

variable "threshold_down" {
  default = "30"
  description = "The cpu value to scale down"
}
variable "policy_type" {
  default = "SimpleScaling"
  description = "The policy type, either SimpleScaling or StepScaling"
}

variable "cooldown_up" {
  default = "300"
  description = "The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start."
}

variable "cooldown_down" {
  default = "600"
  description = "The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start."
}

variable "adjustment_up" {
  default = "1"
  description = "The number of instances to add when the alarm is triggered"
}

variable "adjustment_down" {
  default = "-1"
  description = "The number of instances to remove when the alarm is triggered (the value has to be negative)"
}
variable "num_asg" {
  description = "the number of autoscaling groups passed"
  default = "2"
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
variable "autoscaling_group_name" {
  description = "The name of the AS group this config needs to be applied"
  type = "list"
}
