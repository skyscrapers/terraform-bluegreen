resource "aws_cloudwatch_metric_alarm" "alarm-cpu-down" {
  count               = "${var.num_asg}"
  alarm_name          = "${var.environment}-${var.project}-${var.name}-cpu-down${count.index}"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "${var.evaluation_periods}"
  metric_name         = "CPUUtilization"
  namespace           = "${var.namespace}"
  period              = "${var.period_down}"
  statistic           = "${var.statistic}"
  threshold           = "${var.threshold_down}"

  dimensions {
    AutoScalingGroupName = "${var.autoscaling_group_name[count.index]}"
  }

  alarm_description = "This metric monitors CPU utilization down"
  alarm_actions     = ["${aws_autoscaling_policy.down-cpu.*.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "alarm-cpu-up" {
  count               = "${var.num_asg}"
  alarm_name          = "${var.environment}-${var.project}-${var.name}-cpu-up${count.index}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "${var.evaluation_periods}"
  metric_name         = "CPUUtilization"
  namespace           = "${var.namespace}"
  period              = "${var.period_up}"
  statistic           = "${var.statistic}"
  threshold           = "${var.threshold_up}"

  dimensions {
    AutoScalingGroupName = "${var.autoscaling_group_name[count.index]}"
  }

  alarm_description = "This metric monitors CPU utilization up"
  alarm_actions     = ["${aws_autoscaling_policy.up-cpu.*.arn}"]
}

resource "aws_autoscaling_policy" "up-cpu" {
  count                  = "${var.num_asg}"
  name                   = "${var.environment}-${var.project}-${var.name}-cpu-up${count.index}"
  autoscaling_group_name = "${var.autoscaling_group_name[count.index]}"
  adjustment_type        = "ChangeInCapacity"
  policy_type            = "${var.policy_type}"
  cooldown               = "${var.cooldown_up}"
  scaling_adjustment     = "${var.adjustment_up}"
}

resource "aws_autoscaling_policy" "down-cpu" {
  count                  = "${var.num_asg}"
  name                   = "${var.environment}-${var.project}-${var.name}-cpu-down${count.index}"
  autoscaling_group_name = "${var.autoscaling_group_name[count.index]}"
  adjustment_type        = "ChangeInCapacity"
  policy_type            = "${var.policy_type}"
  cooldown               = "${var.cooldown_down}"
  scaling_adjustment     = "${var.adjustment_down}"
}
