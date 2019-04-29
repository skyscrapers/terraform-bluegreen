variable "name" {
  description = "Name for the created resources"
}

variable "evaluation_periods" {
  default     = "4"
  description = "The number of samples to evaluate"
}

variable "namespace" {
  default     = "AWS/EC2"
  description = "The namespace of the cloudwatch metric"
}

variable "period_down" {
  default     = "120"
  description = "The period in seconds over which the selected metric statistic is applied."
}

variable "period_up" {
  default     = "60"
  description = "The period in seconds over which the selected metric statistic is applied."
}

variable "statistic" {
  default     = "Average"
  description = "The statistic to apply to the alarm's associated metric. Either of the following is supported:"
}

variable "threshold_up" {
  default     = "80"
  description = "The metric value to scale up"
}

variable "threshold_down" {
  default     = "30"
  description = "The metric value to scale down"
}

variable "policy_type" {
  default     = "SimpleScaling"
  description = "The policy type, either SimpleScaling or StepScaling"
}

variable "cooldown_up" {
  default     = "300"
  description = "The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start."
}

variable "cooldown_down" {
  default     = "600"
  description = "The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start."
}

variable "adjustment_up" {
  default     = "1"
  description = "The number of instances to add when the alarm is triggered"
}

variable "adjustment_down" {
  default     = "-1"
  description = "The number of instances to remove when the alarm is triggered (the value has to be negative)"
}

variable "num_asg" {
  description = "The number of autoscaling groups passed"
  default     = "2"
}

variable "autoscaling_group_names" {
  description = "The names of the Auto Scaling Groups this config needs to be applied to"
  type        = "list"
}

variable "metric_name" {
  description = "The metric the scaling is based upon"
  default     = "CPUUtilization"
}

variable "adjustment_type" {
  description = "What typ of adjustment needs to happen"
  default     = "ChangeInCapacity"
}

variable "dimension_name" {
  default = "AutoScalingGroupName"
}

variable "dimension_value" {
  default = "false"
}
