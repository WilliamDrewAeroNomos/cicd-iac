# scale up alarm

resource "aws_autoscaling_policy" "exceed-average-cpu-utilization-scaleup-policy" {
  name                   = "exceed-average-cpu-utilization-scaleup-policy"
  autoscaling_group_name = aws_autoscaling_group.artifactory-autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "exceed-average-cpu-alarm" {
  alarm_name          = "exceed-average-cpu-alarm-scaleup"
  alarm_description   = "CPU utilization greater than an average of 30 percent for two periods of 120 secs"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.artifactory-autoscaling.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.exceed-average-cpu-utilization-scaleup-policy.arn]
}

# scale down alarm
resource "aws_autoscaling_policy" "cpu-utilization-scaledown-policy" {
  name                   = "cpu-utilization-scaledown-policy"
  autoscaling_group_name = aws_autoscaling_group.artifactory-autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "average-cpu-alarm-scaledown" {
  alarm_name          = "average-cpu-alarm-scaledown"
  alarm_description   = "CPU utilization is less than 30 percent for two periods of 120 secs"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "5"

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.artifactory-autoscaling.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.cpu-utilization-scaledown-policy.arn]
}

