# Data source for SNS topic
data "aws_sns_topic" "notification_topic" {
  name = var.sns_topic_name
}

# CloudWatch alarms for DynamoDB tables

resource "aws_cloudwatch_metric_alarm" "dynamodb_throttled_requests" {
  for_each                  = var.dynamodb_table_names
  alarm_name                = "${each.key}_throttled_requests_high"
  actions_enabled           = var.dynamodb_enable_alarms
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 2
  metric_name               = "ThrottledRequests"
  namespace                 = "AWS/DynamoDB"
  period                    = 60
  statistic                 = "Sum"
  threshold                 = var.dynamodb_throttled_requests_threshold
  alarm_description         = "DynamoDB table ${each.key} is experiencing throttled requests"
  alarm_actions             = [data.aws_sns_topic.notification_topic.arn]
  ok_actions                = [data.aws_sns_topic.notification_topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.notification_topic.arn]
  tags                      = var.tags
  treat_missing_data        = "notBreaching"
  
  dimensions = {
    TableName = each.key
  }
}

resource "aws_cloudwatch_metric_alarm" "dynamodb_system_errors" {
  for_each                  = var.dynamodb_table_names
  alarm_name                = "${each.key}_system_errors_high"
  actions_enabled           = var.dynamodb_enable_alarms
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 2
  metric_name               = "SystemErrors"
  namespace                 = "AWS/DynamoDB"
  period                    = 60
  statistic                 = "Sum"
  threshold                 = var.dynamodb_system_errors_threshold
  alarm_description         = "DynamoDB table ${each.key} is experiencing system errors"
  alarm_actions             = [data.aws_sns_topic.notification_topic.arn]
  ok_actions                = [data.aws_sns_topic.notification_topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.notification_topic.arn]
  tags                      = var.tags
  treat_missing_data        = "notBreaching"
  
  dimensions = {
    TableName = each.key
  }
}

resource "aws_cloudwatch_metric_alarm" "dynamodb_conditional_check_failures" {
  for_each                  = var.dynamodb_table_names
  alarm_name                = "${each.key}_conditional_check_failures_high"
  actions_enabled           = var.dynamodb_enable_alarms
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 2
  metric_name               = "ConditionalCheckFailedRequests"
  namespace                 = "AWS/DynamoDB"
  period                    = 60
  statistic                 = "Sum"
  threshold                 = var.dynamodb_conditional_check_failures_threshold
  alarm_description         = "DynamoDB table ${each.key} is experiencing high conditional check failures"
  alarm_actions             = [data.aws_sns_topic.notification_topic.arn]
  ok_actions                = [data.aws_sns_topic.notification_topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.notification_topic.arn]
  tags                      = var.tags
  treat_missing_data        = "notBreaching"
  
  dimensions = {
    TableName = each.key
  }
}

resource "aws_cloudwatch_metric_alarm" "dynamodb_successful_request_latency_read" {
  for_each                  = var.dynamodb_table_names
  alarm_name                = "${each.key}_read_latency_high"
  actions_enabled           = var.dynamodb_enable_alarms
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 2
  metric_name               = "SuccessfulRequestLatency"
  namespace                 = "AWS/DynamoDB"
  period                    = 60
  statistic                 = "Average"
  threshold                 = var.dynamodb_latency_threshold
  alarm_description         = "DynamoDB table ${each.key} read requests are experiencing high latency"
  alarm_actions             = [data.aws_sns_topic.notification_topic.arn]
  ok_actions                = [data.aws_sns_topic.notification_topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.notification_topic.arn]
  tags                      = var.tags
  treat_missing_data        = "notBreaching"
  
  dimensions = {
    TableName   = each.key
    Operation   = "GetItem"
  }
}

resource "aws_cloudwatch_metric_alarm" "dynamodb_successful_request_latency_write" {
  for_each                  = var.dynamodb_table_names
  alarm_name                = "${each.key}_write_latency_high"
  actions_enabled           = var.dynamodb_enable_alarms
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 2
  metric_name               = "SuccessfulRequestLatency"
  namespace                 = "AWS/DynamoDB"
  period                    = 60
  statistic                 = "Average"
  threshold                 = var.dynamodb_latency_threshold
  alarm_description         = "DynamoDB table ${each.key} write requests are experiencing high latency"
  alarm_actions             = [data.aws_sns_topic.notification_topic.arn]
  ok_actions                = [data.aws_sns_topic.notification_topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.notification_topic.arn]
  tags                      = var.tags
  treat_missing_data        = "notBreaching"
  
  dimensions = {
    TableName   = each.key
    Operation   = "PutItem"
  }
}

# AWS Health Events Subscription for DynamoDB service issues
resource "aws_cloudwatch_event_rule" "dynamodb_service_events" {
  name        = "${var.alarm_prefix}-dynamodb-service-events"
  description = "Trigger for DynamoDB service events from AWS Health"

  event_pattern = jsonencode({
    source = ["aws.health"]
    detail-type = [
      "AWS Service Event via CloudWatch Events",
      "AWS Health Abuse Event"
    ]
    detail = {
      service = ["DYNAMODB"]
    }
  })

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "dynamodb_service_events_sns" {
  rule = aws_cloudwatch_event_rule.dynamodb_service_events.name
  arn  = data.aws_sns_topic.notification_topic.arn
}

resource "aws_sns_topic_policy" "notification_topic_allow_events" {
  arn = data.aws_sns_topic.notification_topic.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudWatchEventsToPublish"
        Effect    = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
        Action    = "SNS:Publish"
        Resource  = data.aws_sns_topic.notification_topic.arn
      }
    ]
  })
}

