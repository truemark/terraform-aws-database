# data "aws_caller_identity" "current" {
# }

# data "aws_region" "current" {}

# This is the SNS topic all events and alerts go to.
data "aws_sns_topic" "notification_topic" {
  name = var.sns_topic_name
}

#------------------------------------------------------------------------------
# Create a data source to pull the instance names in preparation for event sub.
data "aws_rds_cluster" "rds_cluster" {
  cluster_identifier = var.db_cluster_id
}
#------------------------------------------------------------------------------
# Generate an rds instance event sub that publishes to the cluster
# specific sns topic.
resource "aws_db_event_subscription" "instance_sub" {
  name      = "${var.db_cluster_id}-instances"
  sns_topic = data.aws_sns_topic.notification_topic.arn

  source_type = "db-instance"
  source_ids  = data.aws_rds_cluster.rds_cluster.cluster_members

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
    "restoration",
  ]

  depends_on = [
    data.aws_sns_topic.notification_topic
  ]
  tags = var.tags
}

#------------------------------------------------------------------------------
# Subscription specific to rds cluster events.
resource "aws_db_event_subscription" "cluster_sub" {
  name      = var.db_cluster_id
  sns_topic = data.aws_sns_topic.notification_topic.arn

  source_type = "db-cluster"
  source_ids  = [var.db_cluster_id]

  event_categories = [
    "configuration change",
    "deletion",
    "failure",
    "failover",
    "global-failover",
    "maintenance",
    "notification",
  ]

  depends_on = [
    data.aws_sns_topic.notification_topic
  ]
  tags = var.tags
}

#------------------------------------------------------------------------------
# This IAM role defines the privs to allow SNS to write to Cloudwatch Logs.
resource "aws_iam_role" "logs_to_cloudwatch" {
  name = "${var.db_cluster_id}-sns-publish-to-cloudwatch-logs"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "sns.amazonaws.com"
        }
      },
    ]
  })
  tags = var.tags
}

# This attachment ties together the logs to cloudwatch role and the logs
# to cloudwatch policy.
resource "aws_iam_policy_attachment" "logs_to_cloudwatch" {
  name       = "${var.db_cluster_id}-attach-sns-publish-to-cloudwatch-logs"
  roles      = ["${aws_iam_role.logs_to_cloudwatch.name}"]
  policy_arn = aws_iam_policy.logs_to_cloudwatch.arn
}

# Create policy that allows SNS to write to Cloudwatch.
resource "aws_iam_policy" "logs_to_cloudwatch" {
  name   = "${var.db_cluster_id}-sns-publish-to-cloudwatch-logs"
  path   = "/"
  policy = data.aws_iam_policy_document.logs_to_cloudwatch.json
  tags   = var.tags
}

# This policy doc defines all privs necessary for SNS to write to Cloudwatch.
data "aws_iam_policy_document" "logs_to_cloudwatch" {
  statement {
    sid = "WriteToLogs"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutMetricFilter",
      "logs:PutRetentionPolicy"
    ]

    resources = [
      "*",
    ]
  }
}

#------------------------------------------------------------------------------
# The code below defines alarms based upon Cloudwatch metrics.
# TODO: create cloudwatch filter alarms
# https://spin.atomicobject.com/2021/04/07/aws-cloudwatch-metric-filter-alarm-terraform/

locals {
  thresholds = {
    CPUUtilizationEvaluationPeriods    = min(max(var.cpu_utilization_evaluation_periods, 0), 100)
    CPUUtilizationThreshold            = min(max(var.cpu_utilization_threshold, 0), 100)
    DiskQueueDepthEvaluationPeriods    = max(var.disk_queue_depth_evaluation_periods, 0)
    DiskQueueDepthThreshold            = max(var.disk_queue_depth_threshold, 0)
    DiskQueueDataPointsToAlarm         = var.disk_queue_data_points_to_alarm
    FreeableMemoryEvaluationPeriods    = max(var.disk_queue_depth_evaluation_periods, 0)
    FreeableMemoryThreshold            = max(var.freeable_memory_threshold, 0)
    PercentFreeMemoryEvaluationPeriods = max(var.percent_free_memory_evaluation_periods, 0)
    PercentFreeMemoryThreshold         = max(var.percent_free_memory_threshold, 0)
    FreeStorageSpaceThreshold          = max(var.free_storage_space_threshold, 0)
    SwapUsageThreshold                 = max(var.swap_usage_threshold, 0)
    SwapUsageEvaluationPeriods         = max(var.swap_usage_evaluation_periods, 0)
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm#example-with-an-expression
resource "aws_cloudwatch_metric_alarm" "percent_free_memory_low" {
  for_each                  = var.db_cluster_members
  alarm_name                = "${each.key}_percent_free_memory_low"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["PercentFreeMemoryEvaluationPeriods"]
  threshold                 = local.thresholds["PercentFreeMemoryThreshold"]
  alarm_description         = "Percent of freeable memory is low."
  alarm_actions             = [data.aws_sns_topic.notification_topic.arn]
  ok_actions                = [data.aws_sns_topic.notification_topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.notification_topic.arn]
  treat_missing_data        = "breaching"
  tags                      = var.tags

  metric_query {
    id          = "e1"
    expression  = "m2/(m1*1024)*100"
    label       = "% Freeable Memory"
    return_data = "true"
  }

  metric_query {
    id = "m2"

    metric {
      metric_name = "FreeableMemory"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Minimum"
      unit        = "Bytes"
      dimensions = {
        "rds-instance" = "${each.key}"
      }
    }
  }

  metric_query {
    id = "m1"

    metric {
      metric_name = "RDS-total-memory"
      namespace   = "YL"
      period      = "60"
      stat        = "Maximum"
      unit        = "Kilobytes"
      dimensions = {
        "rds-instance" = "${each.key}"
      }
    }
  }

}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_high" {
  for_each                  = var.db_cluster_members
  alarm_name                = "${each.key}_cpu_utilization_high"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["CPUUtilizationEvaluationPeriods"]
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["CPUUtilizationThreshold"]
  alarm_description         = "Average database CPU utilization too high"
  alarm_actions             = [data.aws_sns_topic.notification_topic.arn]
  ok_actions                = [data.aws_sns_topic.notification_topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.notification_topic.arn]
  treat_missing_data        = "breaching"
  tags                      = var.tags
  dimensions = {
    DBInstanceIdentifier = each.key
  }
}

resource "aws_cloudwatch_metric_alarm" "disk_queue_depth_high" {
  for_each                  = var.db_cluster_members
  alarm_name                = "${each.key}_disk_queue_depth_high"
  comparison_operator       = "GreaterThanThreshold"
  datapoints_to_alarm       = local.thresholds["DiskQueueDataPointsToAlarm"]
  evaluation_periods        = local.thresholds["DiskQueueDepthEvaluationPeriods"]
  metric_name               = "DiskQueueDepth"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["DiskQueueDepthThreshold"]
  alarm_description         = "Average database disk queue depth too high, performance may suffer"
  alarm_actions             = [data.aws_sns_topic.notification_topic.arn]
  ok_actions                = [data.aws_sns_topic.notification_topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.notification_topic.arn]
  treat_missing_data        = "breaching"
  tags                      = var.tags
  dimensions = {
    DBInstanceIdentifier = each.key
  }
}

resource "aws_cloudwatch_metric_alarm" "freeable_memory_low" {
  for_each                  = var.db_cluster_members
  alarm_name                = "${each.key}_freeable_memory_low"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "FreeableMemory"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["FreeableMemoryThreshold"]
  alarm_description         = "Average database freeable memory too low, performance may suffer"
  alarm_actions             = [data.aws_sns_topic.notification_topic.arn]
  ok_actions                = [data.aws_sns_topic.notification_topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.notification_topic.arn]
  tags                      = var.tags
  treat_missing_data        = "breaching"
  dimensions = {
    DBInstanceIdentifier = each.key
  }
}

resource "aws_cloudwatch_metric_alarm" "free_storage_space_low" {
  for_each            = var.db_cluster_members
  alarm_name          = "${each.key}_free_storage_space_low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeLocalStorage"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = local.thresholds["FreeStorageSpaceThreshold"]
  alarm_description   = "Average database free storage space low"
  alarm_actions       = [data.aws_sns_topic.notification_topic.arn]
  ok_actions          = [data.aws_sns_topic.notification_topic.arn]
  tags                = var.tags
  dimensions = {
    DBInstanceIdentifier = each.key
  }
}

resource "aws_cloudwatch_metric_alarm" "swap_usage_high" {
  for_each                  = var.db_cluster_members
  alarm_name                = "${each.key}_swap_usage_high"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["SwapUsageEvaluationPeriods"]
  metric_name               = "SwapUsage"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["SwapUsageThreshold"]
  alarm_description         = "Average database swap usage too high, performance may suffer"
  alarm_actions             = [data.aws_sns_topic.notification_topic.arn]
  ok_actions                = [data.aws_sns_topic.notification_topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.notification_topic.arn]
  tags                      = var.tags
  treat_missing_data        = "breaching"
  dimensions = {
    DBInstanceIdentifier = each.key
  }
}


#------------------------------------------------------------------------------
# This policy is very touchy and must exist as is, because RDS Events do not
# actually come from within the same account. They come from another account,
# according to AWS Support.
# data "aws_iam_policy_document" "sns_cloudwatch_topic_policy" {

#   statement {
#     sid = "PolicyForCWToSNS"

#     actions = [
#       "SNS:Subscribe",
#       "SNS:SetTopicAttributes",
#       "SNS:RemovePermission",
#       "SNS:Receive",
#       "SNS:Publish",
#       "SNS:ListSubscriptionsByTopic",
#       "SNS:GetTopicAttributes",
#       "SNS:DeleteTopic",
#       "SNS:AddPermission",
#     ]

#     effect    = "Allow"
#     resources = toset([data.aws_sns_topic.notification_topic.arn])

#     principals {
#       type        = "AWS"
#       identifiers = ["*"]
#     }

#     condition {
#       test     = "StringLike"
#       variable = "AWS:SourceArn"
#       values   = ["arn:aws:rds:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
#     }
#   }

#   statement {
#     sid       = "AllowEventNotifications"
#     actions   = ["sns:Publish"]
#     resources = toset([data.aws_sns_topic.notification_topic.arn])

#     principals {
#       type        = "Service"
#       identifiers = ["rds.amazonaws.com", "cloudwatch.amazonaws.com"]
#     }
#   }

# }
#------------------------------------------------------------------------------
# Yes, this is nearly an exact copy of sns_cloudwatch_topic_policy.
# aws_iam_policy_document data source can only be attached to one policy, and
# it cannot be parameterized in a useful way. I agree, this is ugly.
# data "aws_iam_policy_document" "sns_rds_events_topic_policy" {

#   statement {
#     sid = "PolicyForRDSToSNS"

#     actions = [
#       "SNS:Subscribe",
#       "SNS:SetTopicAttributes",
#       "SNS:RemovePermission",
#       "SNS:Receive",
#       "SNS:Publish",
#       "SNS:ListSubscriptionsByTopic",
#       "SNS:GetTopicAttributes",
#       "SNS:DeleteTopic",
#       "SNS:AddPermission",
#     ]


#     effect    = "Allow"
#     resources = toset([data.aws_sns_topic.notification_topic.arn])

#     principals {
#       type        = "AWS"
#       identifiers = ["*"]
#     }

#     condition {
#       test     = "StringLike"
#       variable = "AWS:SourceArn"
#       values   = ["arn:aws:rds:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
#     }
#   }

#   statement {
#     sid       = "AllowEventNotifications"
#     actions   = ["sns:Publish"]
#     resources = toset([data.aws_sns_topic.notification_topic.arn])

#     principals {
#       type        = "Service"
#       identifiers = ["rds.amazonaws.com", "cloudwatch.amazonaws.com"]
#     }
#   }

# }
