resource "aws_cloudwatch_metric_alarm" "alarm-cpu-down" {
  alarm_name = "${var.environment}-${var.project}-${var.name}-cpu-down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "${var.evaluation_periods}"
  metric_name = "CPUUtilization"
  namespace = "${var.namespace}"
  period = "${var.period_down}"
  statistic = "${var.statistic}"
  threshold = "${var.threshold_down}"
  dimensions {
    AutoScalingGroupName = "${var.autoscaling_group_name}"
  }
  alarm_description = "This metric monitors CPU utilization down"
  alarm_actions = ["${aws_autoscaling_policy.down-cpu.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "alarm-cpu-up" {
  alarm_name = "${var.environment}-${var.project}-${var.name}-cpu-up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "${var.evaluation_periods}"
  metric_name = "CPUUtilization"
  namespace = "${var.namespace}"
  period = "${var.period_up}"
  statistic = "${var.statistic}"
  threshold = "${var.threshold_up}"
  dimensions {
    AutoScalingGroupName = "${var.autoscaling_group_name}"
  }
  alarm_description = "This metric monitors CPU utilization up"
  alarm_actions = ["${aws_autoscaling_policy.up-cpu.arn}"]
}

resource "aws_autoscaling_policy" "up-cpu" {
  name = "${var.environment}-${var.project}-${var.name}-cpu-up"
  autoscaling_group_name = "${var.autoscaling_group_name}"
  adjustment_type = "ChangeInCapacity"
  policy_type = "${var.policy_type}"
  cooldown = "${var.cooldown_up}"
  scaling_adjustment = "${var.adjustment_up}"
}

resource "aws_autoscaling_policy" "down-cpu" {
  name = "${var.environment}-${var.project}-${var.name}-cpu-down"
  autoscaling_group_name = "${module.api.autoscaling_group_name}"
  adjustment_type = "ChangeInCapacity"
  policy_type = "${var.policy_type}"
  cooldown = "${var.cooldown_down}"
  scaling_adjustment = "${var.adjustment_down}"
}
