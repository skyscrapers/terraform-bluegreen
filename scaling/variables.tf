variable "name" {
  type        = string
  description = "Name for the created resources"
}

variable "evaluation_periods" {
  type        = number
  description = "The number of samples to evaluate"
  default     = 4
}

variable "namespace" {
  type        = string
  description = "The namespace of the cloudwatch metric"
  default     = "AWS/EC2"
}

variable "period_down" {
  type        = number
  description = "The period in seconds over which the selected metric statistic is applied."
  default     = 120
}

variable "period_up" {
  type        = number
  description = "The period in seconds over which the selected metric statistic is applied."
  default     = 60
}

variable "statistic" {
  type        = string
  description = "The statistic to apply to the alarm's associated metric. Either of the following is supported:"
  default     = "Average"
}

variable "threshold_up" {
  type        = number
  description = "The metric value to scale up"
  default     = 80
}

variable "threshold_down" {
  type        = number
  description = "The metric value to scale down"
  default     = 30
}

variable "policy_type" {
  type        = string
  description = "The policy type, either SimpleScaling or StepScaling"
  default     = "SimpleScaling"
}

variable "cooldown_up" {
  type        = number
  description = "The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start."
  default     = 300
}

variable "cooldown_down" {
  type        = number
  description = "The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start."
  default     = 600
}

variable "adjustment_up" {
  type        = number
  description = "The number of instances to add when the alarm is triggered"
  default     = 1
}

variable "adjustment_down" {
  type        = number
  description = "The number of instances to remove when the alarm is triggered (the value has to be negative)"
  default     = -1
}

variable "num_asg" {
  type        = number
  description = "The number of autoscaling groups passed"
  default     = 2
}

variable "autoscaling_group_names" {
  type        = list(string)
  description = "The names of the Auto Scaling Groups this config needs to be applied to"
}

variable "metric_name" {
  type        = string
  description = "The metric the scaling is based upon"
  default     = "CPUUtilization"
}

variable "adjustment_type" {
  type        = string
  description = "What typ of adjustment needs to happen"
  default     = "ChangeInCapacity"
}

variable "dimension_name" {
  type    = string
  default = "AutoScalingGroupName"
}

variable "dimension_value" {
  type    = string
  default = null
}

variable "datapoints_to_alarm_up" {
  type        = number
  description = "The number of datapoints that must be breaching to trigger the scale UP alarm"
  default     = null
}

variable "datapoints_to_alarm_down" {
  type        = number
  description = "The number of datapoints that must be breaching to trigger the scale DOWN alarm"
  default     = null
}
