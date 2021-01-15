resource "aws_cloudwatch_metric_alarm" "alarm_down" {
  count               = var.num_asg
  alarm_name          = "${var.name}-down${count.index}"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.metric_name
  namespace           = var.namespace
  period              = var.period_down
  statistic           = var.statistic
  threshold           = var.threshold_down
  datapoints_to_alarm = var.datapoints_to_alarm_down

  dimensions = {
    var.dimension_name = coalesce(var.dimension_value, var.autoscaling_group_names[count.index])
  }

  alarm_description = "This metric monitors CPU utilization down"
  alarm_actions     = aws_autoscaling_policy.down.*.arn
}

resource "aws_cloudwatch_metric_alarm" "alarm_up" {
  count               = var.num_asg
  alarm_name          = "${var.name}-up${count.index}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.metric_name
  namespace           = var.namespace
  period              = var.period_up
  statistic           = var.statistic
  threshold           = var.threshold_up
  datapoints_to_alarm = var.datapoints_to_alarm_up

  dimensions = {
    var.dimension_name = coalesce(var.dimension_value, var.autoscaling_group_names[count.index])
  }

  alarm_description = "This metric monitors CPU utilization up"
  alarm_actions     = aws_autoscaling_policy.up.*.arn
}

resource "aws_autoscaling_policy" "up" {
  count                  = var.num_asg
  name                   = "${var.name}-up${count.index}"
  autoscaling_group_name = var.autoscaling_group_names[count.index]
  adjustment_type        = var.adjustment_type
  policy_type            = var.policy_type
  cooldown               = var.cooldown_up
  scaling_adjustment     = var.adjustment_up
}

resource "aws_autoscaling_policy" "down" {
  count                  = var.num_asg
  name                   = "${var.name}-down${count.index}"
  autoscaling_group_name = var.autoscaling_group_names[count.index]
  adjustment_type        = var.adjustment_type
  policy_type            = var.policy_type
  cooldown               = var.cooldown_down
  scaling_adjustment     = var.adjustment_down
}
