# This is the SNS topic all events and alerts go to.
data "aws_sns_topic" "topic" {
  name = var.sns_topic_name
}

#------------------------------------------------------------------------------
# Generate an rds instance event sub that publishes to the sns topic.
resource "aws_db_event_subscription" "instance_sub" {
  name        = "${var.db_instance_id}-instances"
  sns_topic   = data.aws_sns_topic.topic.arn
  source_type = "db-instance"
  source_ids  = [var.db_instance_id]
  tags        = var.tags

  event_categories = [
    "availability",
    "deletion",
    "failover",
    "failure",
    "low storage",
    "maintenance",
    "notification",
    "read replica",
    "recovery",
    "restoration"
  ]
}

#------------------------------------------------------------------------------
# The code below defines alarms based upon Cloudwatch metrics.

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_high" {
  count                     = var.create_cpu_utilization_alarm ? 1 : 0
  alarm_name                = "${var.db_instance_id}_cpu_utilization_high"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["CPUUtilizationEvaluationPeriods"]
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["CPUUtilizationThreshold"]
  alarm_description         = "Average database CPU utilization too high"
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  treat_missing_data        = "breaching"
  tags                      = var.tags
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "disk_queue_depth_high" {
  count                     = var.create_disk_queue_depth_alarm ? 1 : 0
  alarm_name                = "${var.db_instance_id}_disk_queue_depth_high"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["DiskQueueDepthEvaluationPeriods"]
  metric_name               = "DiskQueueDepth"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["DiskQueueDepthThreshold"]
  alarm_description         = "Average database disk queue depth too high, performance may suffer"
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  treat_missing_data        = "breaching"
  tags                      = var.tags
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "freeable_memory_low" {
  count                     = var.create_freeable_memory_alarm ? 1 : 0
  alarm_name                = "${var.db_instance_id}_freeable_memory_low"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "FreeableMemory"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["FreeableMemoryThreshold"]
  alarm_description         = "Average database freeable memory too low, performance may suffer"
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  treat_missing_data        = "breaching"
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "free_storage_space_low" {
  count               = var.create_free_storage_space_alarm ? 1 : 0
  alarm_name          = "${var.db_instance_id}_free_storage_space_low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = local.thresholds["FreeStorageSpaceThreshold"]
  alarm_description   = "Average database free storage space low"
  alarm_actions       = [data.aws_sns_topic.topic.arn]
  ok_actions          = [data.aws_sns_topic.topic.arn]
  tags                = var.tags
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "swap_usage_high" {
  count                     = var.create_swap_usage_alarm ? 1 : 0
  alarm_name                = "${var.db_instance_id}_swap_usage_high"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "SwapUsage"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["SwapUsageThreshold"]
  alarm_description         = "Average database swap usage too high, performance may suffer"
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  treat_missing_data        = "breaching"
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}
