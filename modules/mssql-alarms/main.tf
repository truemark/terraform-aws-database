data "aws_caller_identity" "default" {
}

locals {
  namespace = var.namespace
}
#------------------------------------------------------------------------------
# This is the SNS topic all events and alerts go to.
data "aws_sns_topic" "notification_topic" {
  name = var.sns_topic_name
}

#------------------------------------------------------------------------------
# Generate an rds instance event sub that publishes to the sns topic.
resource "aws_db_event_subscription" "instance_sub" {
  name      = var.db_instance_id
  sns_topic = data.aws_sns_topic.notification_topic.arn

  source_type = "db-instance"

  source_ids = [var.db_instance_id]
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

  tags = var.tags
}

#------------------------------------------------------------------------------
# Define all alarms.
resource "aws_cloudwatch_metric_alarm" "cpu_utilization_high" {
  actions_enabled           = var.cpu_utilization_high_actions_enabled
  alarm_name                = "${var.db_instance_id}_cpu_utilization_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["CPUUtilizationEvaluationPeriods"]
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["CPUUtilizationThreshold"]
  alarm_description         = "Average database CPU utilization high."
  alarm_actions             = [data.aws_sns_topic.notification_topic.arn]
  ok_actions                = [data.aws_sns_topic.notification_topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.notification_topic.arn]
  treat_missing_data        = "breaching"
  tags                      = var.tags
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "disk_queue_depth_high" {
  actions_enabled           = var.disk_queue_depth_high_actions_enabled
  alarm_name                = "${var.db_instance_id}_disk_queue_depth_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["DiskQueueDepthEvaluationPeriods"]
  metric_name               = "DiskQueueDepth"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["DiskQueueDepthThreshold"]
  alarm_description         = "Average database disk queue depth high. i/o performance will suffer. Check db activity."
  alarm_actions             = [data.aws_sns_topic.notification_topic.arn]
  ok_actions                = [data.aws_sns_topic.notification_topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.notification_topic.arn]
  treat_missing_data        = "breaching"
  tags                      = var.tags
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "freeable_memory_low" {
  actions_enabled           = var.freeable_memory_low_actions_enabled
  alarm_name                = "${var.db_instance_id}_freeable_memory_low_static"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = local.thresholds["FreeableMemoryEvaluationPeriods"]
  metric_name               = "FreeableMemory"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["FreeableMemoryThreshold"]
  alarm_description         = "Average database freeable memory low. Performance will suffer, instance may crash."
  alarm_actions             = [data.aws_sns_topic.notification_topic.arn]
  ok_actions                = [data.aws_sns_topic.notification_topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.notification_topic.arn]
  tags                      = var.tags
  treat_missing_data        = "breaching"
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "free_storage_space_low" {
  actions_enabled     = var.free_storage_space_low_actions_enabled
  alarm_name          = "${var.db_instance_id}_free_storage_space_low_static"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = local.thresholds["FreeStorageSpaceEvaluationPeriods"]
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = local.thresholds["FreeStorageSpaceThreshold"]
  alarm_description   = "Average database free storage space low. Cleanup local storage immediately."
  alarm_actions       = [data.aws_sns_topic.notification_topic.arn]
  ok_actions          = [data.aws_sns_topic.notification_topic.arn]
  tags                = var.tags
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "db_connections_high" {
  actions_enabled           = var.db_connections_high_actions_enabled
  alarm_name                = "${var.db_instance_id}_db_connections_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["DatabaseConnectionsEvaluationPeriods"]
  metric_name               = "DatabaseConnections"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["DatabaseConnectionsThreshold"]
  alarm_description         = "The number of db connections is high. Check db instance activity."
  alarm_actions             = [data.aws_sns_topic.notification_topic.arn]
  ok_actions                = [data.aws_sns_topic.notification_topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.notification_topic.arn]
  treat_missing_data        = "breaching"
  tags                      = var.tags
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "db_load_high" {
  actions_enabled           = var.db_load_high_actions_enabled
  alarm_name                = "${var.db_instance_id}_db_load_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["DBLoadEvaluationPeriods"]
  metric_name               = "DBLoad"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["DBLoadThreshold"]
  alarm_description         = "The DBLoad statistic is high. Check db instance activity."
  alarm_actions             = [data.aws_sns_topic.notification_topic.arn]
  ok_actions                = [data.aws_sns_topic.notification_topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.notification_topic.arn]
  treat_missing_data        = "breaching"
  tags                      = var.tags
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "db_load_cpu_high" {
  actions_enabled           = var.db_load_cpu_high_actions_enabled
  alarm_name                = "${var.db_instance_id}_db_load_cpu_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["DBLoadCPUEvaluationPeriods"]
  metric_name               = "DBLoadCPU"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["DBLoadCPUThreshold"]
  alarm_description         = "The DBLoadCPU statistic is high. Check db instance activity."
  alarm_actions             = [data.aws_sns_topic.notification_topic.arn]
  ok_actions                = [data.aws_sns_topic.notification_topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.notification_topic.arn]
  treat_missing_data        = "breaching"
  tags                      = var.tags
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "db_load_non_cpu_high" {
  actions_enabled           = var.db_load_non_cpu_high_actions_enabled
  alarm_name                = "${var.db_instance_id}_db_load_non_cpu_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["DBLoadNonCPUEvaluationPeriods"]
  metric_name               = "DBLoadNonCPU"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["DBLoadNonCPUThreshold"]
  alarm_description         = "The DBLoadNonCPU statistic is high. Check db instance activity."
  alarm_actions             = [data.aws_sns_topic.notification_topic.arn]
  ok_actions                = [data.aws_sns_topic.notification_topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.notification_topic.arn]
  treat_missing_data        = "breaching"
  tags                      = var.tags
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "failed_sql_server_agent_jobs_count_high" {
  actions_enabled           = var.failed_sql_server_agent_jobs_count_high_actions_enabled
  alarm_name                = "${var.db_instance_id}_failed_sql_server_agent_jobs_count_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["FailedSQLServerAgentJobsCountEvaluationPeriods"]
  metric_name               = "FailedSQLServerAgentJobsCount"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["FailedSQLServerAgentJobsCountThreshold"]
  alarm_description         = "SQL Server agent job failures are detected. Check the SQL agent."
  alarm_actions             = [data.aws_sns_topic.notification_topic.arn]
  ok_actions                = [data.aws_sns_topic.notification_topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.notification_topic.arn]
  treat_missing_data        = "breaching"
  tags                      = var.tags
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "temp_db_available_data_space_low" {
  actions_enabled           = var.temp_db_available_data_space_low_actions_enabled
  alarm_name                = "${var.db_instance_id}_temp_db_available_data_space_low_static"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = local.thresholds["TempDbAvailableDataSpaceEvaluationPeriods"]
  metric_name               = "TempDbAvailableDataSpace"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["TempDbAvailableDataSpaceThreshold"]
  alarm_description         = "The amount of temp data space in use. Check temp db usage."
  alarm_actions             = [data.aws_sns_topic.notification_topic.arn]
  ok_actions                = [data.aws_sns_topic.notification_topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.notification_topic.arn]
  treat_missing_data        = "breaching"
  tags                      = var.tags
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "temp_db_available_log_space_low" {
  actions_enabled           = var.temp_db_available_log_space_low_actions_enabled
  alarm_name                = "${var.db_instance_id}_temp_db_available_log_space_low_static"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = local.thresholds["TempDbAvailableLogSpaceEvaluationPeriods"]
  metric_name               = "TempDbAvailableLogSpace"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["TempDbAvailableLogSpaceThreshold"]
  alarm_description         = "The amount of temp log space in use. Check temp db usage."
  alarm_actions             = [data.aws_sns_topic.notification_topic.arn]
  ok_actions                = [data.aws_sns_topic.notification_topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.notification_topic.arn]
  treat_missing_data        = "breaching"
  tags                      = var.tags
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "temp_db_data_file_usage_high" {
  actions_enabled           = var.temp_db_data_file_usage_high_actions_enabled
  alarm_name                = "${var.db_instance_id}_temp_db_data_file_usage_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["TempDbDataFileUsageEvaluationPeriods"]
  metric_name               = "TempDbDataFileUsage"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["TempDbDataFileUsageThreshold"]
  alarm_description         = "The amount of temp data space in use. Check temp db usage."
  alarm_actions             = [data.aws_sns_topic.notification_topic.arn]
  ok_actions                = [data.aws_sns_topic.notification_topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.notification_topic.arn]
  treat_missing_data        = "breaching"
  tags                      = var.tags
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "temp_db_log_file_usage_high" {
  actions_enabled           = var.temp_db_log_file_usage_high_actions_enabled
  alarm_name                = "${var.db_instance_id}_temp_db_log_file_usage_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["TempDbLogFileUsageEvaluationPeriods"]
  metric_name               = "TempDbLogFileUsage"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["TempDbLogFileUsageThreshold"]
  alarm_description         = "The amount of temp log space in use. Check temp db usage."
  alarm_actions             = [data.aws_sns_topic.notification_topic.arn]
  ok_actions                = [data.aws_sns_topic.notification_topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.notification_topic.arn]
  treat_missing_data        = "breaching"
  tags                      = var.tags
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

# NetworkReceiveThroughput anomaly alarm
resource "aws_cloudwatch_metric_alarm" "network_receive_throughput" {
  count                     = var.implement_anomaly_alarms ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.notification_topic.arn]
  alarm_description         = "NetworkReceiveThroughput anomaly detected."
  alarm_name                = "${var.db_instance_id}_network_receive_throughput_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["NetworkReceiveThroughputEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.notification_topic.arn]
  ok_actions                = [data.aws_sns_topic.notification_topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "NetworkReceiveThroughput (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "NetworkReceiveThroughput"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# NetworkTransmitThroughput anomaly alarm
resource "aws_cloudwatch_metric_alarm" "network_transmit_throughput" {
  count                     = var.create_network_transmit_throughput ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.notification_topic.arn]
  alarm_description         = "NetworkTransmitThroughput anomaly detected."
  alarm_name                = "${var.db_instance_id}_network_transmit_throughput_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["NetworkTransmitThroughputEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.notification_topic.arn]
  ok_actions                = [data.aws_sns_topic.notification_topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "NetworkTransmitThroughput (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "NetworkTransmitThroughput"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# ReadIOPS anomaly alarm
resource "aws_cloudwatch_metric_alarm" "read_iops" {
  count                     = var.implement_anomaly_alarms ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.notification_topic.arn]
  alarm_description         = "ReadIOPS anomaly detected."
  alarm_name                = "${var.db_instance_id}_read_iops_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["ReadIOPSEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.notification_topic.arn]
  ok_actions                = [data.aws_sns_topic.notification_topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "ReadIOPS (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "ReadIOPS"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# ReadLatency anomaly alarm
resource "aws_cloudwatch_metric_alarm" "read_latency" {
  count                     = var.implement_anomaly_alarms ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.notification_topic.arn]
  alarm_description         = "ReadLatency anomaly detected."
  alarm_name                = "${var.db_instance_id}_read_latency_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["ReadLatencyEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.notification_topic.arn]
  ok_actions                = [data.aws_sns_topic.notification_topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "ReadLatency (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "ReadLatency"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# ReadThroughput anomaly alarm
resource "aws_cloudwatch_metric_alarm" "read_throughput" {
  count                     = var.implement_anomaly_alarms ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.notification_topic.arn]
  alarm_description         = "ReadThroughput anomaly detected."
  alarm_name                = "${var.db_instance_id}_read_throughput_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["ReadThroughputEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.notification_topic.arn]
  ok_actions                = [data.aws_sns_topic.notification_topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "ReadThroughput (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "ReadThroughput"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# SwapUsage anomaly alarm
resource "aws_cloudwatch_metric_alarm" "swap_usage" {
  count                     = var.implement_anomaly_alarms ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.notification_topic.arn]
  alarm_description         = "SwapUsage anomaly detected."
  alarm_name                = "${var.db_instance_id}_swap_usage_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["SwapUsageEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.notification_topic.arn]
  ok_actions                = [data.aws_sns_topic.notification_topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "SwapUsage (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "SwapUsage"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}


# WriteIOPS anomaly alarm
resource "aws_cloudwatch_metric_alarm" "write_iops" {
  count                     = var.implement_anomaly_alarms ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.notification_topic.arn]
  alarm_description         = "WriteIOPS anomaly detected."
  alarm_name                = "${var.db_instance_id}_write_iops_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["WriteIOPSEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.notification_topic.arn]
  ok_actions                = [data.aws_sns_topic.notification_topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "WriteIOPS (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "WriteIOPS"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# WriteLatency anomaly alarm
resource "aws_cloudwatch_metric_alarm" "write_latency" {
  count                     = var.implement_anomaly_alarms ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.notification_topic.arn]
  alarm_description         = "WriteLatency anomaly detected."
  alarm_name                = "${var.db_instance_id}_write_latency_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["WriteLatencyEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.notification_topic.arn]
  ok_actions                = [data.aws_sns_topic.notification_topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "WriteLatency (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "WriteLatency"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# WriteThroughput anomaly alarm
resource "aws_cloudwatch_metric_alarm" "write_throughput" {
  count                     = var.implement_anomaly_alarms ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.notification_topic.arn]
  alarm_description         = "WriteThroughput anomaly detected."
  alarm_name                = "${var.db_instance_id}_write_throughput_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["WriteThroughputEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.notification_topic.arn]
  ok_actions                = [data.aws_sns_topic.notification_topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "WriteThroughput (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "WriteThroughput"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

#----------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "recompilations_per_second_static" {
  count                     = var.create_recompilations_per_second_static ? 1 : 0
  actions_enabled           = var.recompilations_per_second_static_actions_enabled
  alarm_name                = "${var.db_instance_id}_recompilations_per_second_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["RecompilationsPerSecondEvaluationPeriods"]
  metric_name               = "recompilations-per-second"
  namespace                 = local.namespace
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["RecompilationsPerSecondThreshold"]
  alarm_description         = "The total number of recompilations (hard parses) as of this specific point in time."
  alarm_actions             = [data.aws_sns_topic.notification_topic.arn]
  ok_actions                = [data.aws_sns_topic.notification_topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.notification_topic.arn]
  treat_missing_data        = "breaching"
  tags                      = var.tags
  dimensions = {
    server_name = var.db_instance_id
  }
}

# RecompilationsPerSecond anomaly alarm
resource "aws_cloudwatch_metric_alarm" "recompilations_per_second_anomaly" {
  count                     = var.implement_anomaly_alarms ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.notification_topic.arn]
  alarm_description         = "RecompilationsPerSecond anomaly detected."
  alarm_name                = "${var.db_instance_id}_recompilations_per_second_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["RecompilationsPerSecondEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.notification_topic.arn]
  ok_actions                = [data.aws_sns_topic.notification_topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "recompilations-per-second (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "recompilations-per-second"
      namespace   = local.namespace
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        server_name = var.db_instance_id
      }
    }
  }
}

#----------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "deadlocks_per_second_diff_static" {
  count                     = var.create_deadlocks_per_second_static ? 1 : 0
  alarm_name                = "${var.db_instance_id}_deadlocks_per_second_diff_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["DeadlocksPerSecondEvaluationPeriods"]
  threshold                 = local.thresholds["DeadlocksPerSecondThreshold"]
  alarm_description         = "Returns the difference between each deadlocks_per_second value in the time series and the preceding value of deadlocks_per_second from that time series."
  alarm_actions             = [data.aws_sns_topic.notification_topic.arn]
  ok_actions                = [data.aws_sns_topic.notification_topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.notification_topic.arn]
  treat_missing_data        = "breaching"
  tags                      = var.tags
  actions_enabled           = var.deadlocks_per_second_diff_static_actions_enabled

  metric_query {
    id          = "e1"
    expression  = "DIFF(m1)"
    label       = "deadlocks-per-second-diff"
    return_data = "true"
  }

  metric_query {
    id = "m1"
    metric {
      metric_name = "deadlocks-per-second"
      namespace   = local.namespace
      period      = "60"
      stat        = "Maximum"
      dimensions = {
        server_name = var.db_instance_id
      }
    }
  }
}

# DeadlocksPerSecond anomaly alarm
resource "aws_cloudwatch_metric_alarm" "deadlocks_per_second_anomaly" {
  count                     = var.implement_anomaly_alarms ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.notification_topic.arn]
  alarm_description         = "DeadlocksPerSecond anomaly detected."
  alarm_name                = "${var.db_instance_id}_deadlocks_per_second_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["DeadlocksPerSecondEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.notification_topic.arn]
  ok_actions                = [data.aws_sns_topic.notification_topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "deadlocks-per-second (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "deadlocks-per-second"
      namespace   = local.namespace
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        server_name = var.db_instance_id
      }
    }
  }
}

#----------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "lock_waits_per_second_diff_static" {
  count                     = var.create_lock_waits_per_second_static ? 1 : 0
  actions_enabled           = var.lock_waits_per_second_diff_static_actions_enabled
  alarm_name                = "${var.db_instance_id}_lock_waits_per_second_diff_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["LockWaitsPerSecondEvaluationPeriods"]
  threshold                 = local.thresholds["LockWaitsPerSecondThreshold"]
  alarm_description         = "Returns the difference between each lock_waits_per_second value in the time series and the preceding value of lock_waits_per_second from that time series."
  alarm_actions             = var.lock_waits_per_second_diff_static_actions_enabled == true ? [data.aws_sns_topic.notification_topic.arn] : null
  ok_actions                = var.lock_waits_per_second_diff_static_actions_enabled == true ? [data.aws_sns_topic.notification_topic.arn] : null
  insufficient_data_actions = var.lock_waits_per_second_diff_static_actions_enabled == true ? [data.aws_sns_topic.notification_topic.arn] : null
  treat_missing_data        = "breaching"
  tags                      = var.tags

  metric_query {
    id          = "e1"
    expression  = "DIFF(m1)"
    label       = "lock-waits-per-second-diff"
    return_data = "true"
  }

  metric_query {
    id = "m1"
    metric {
      metric_name = "lock-waits-per-second"
      namespace   = local.namespace
      period      = "60"
      stat        = "Maximum"
      dimensions = {
        server_name = var.db_instance_id
      }
    }
  }
}

# LockWaitsPerSecond anomaly alarm
resource "aws_cloudwatch_metric_alarm" "lock_waits_per_second_anomaly" {
  count                     = var.implement_anomaly_alarms ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.notification_topic.arn]
  alarm_description         = "LockWaitsPerSecond anomaly detected."
  alarm_name                = "${var.db_instance_id}_lock_waits_per_second_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["LockWaitsPerSecondEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.notification_topic.arn]
  ok_actions                = [data.aws_sns_topic.notification_topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "lock-waits-per-second (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "lock-waits-per-second"
      namespace   = local.namespace
      period      = "60"
      stat        = "Maximum"
      dimensions = {
        server_name = var.db_instance_id
      }
    }
  }
}

#----------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "page_life_expectancy_static" {
  count                     = var.create_page_life_expectancy_static ? 1 : 0
  actions_enabled           = var.page_life_expectancy_static_actions_enabled
  alarm_name                = "${var.db_instance_id}_page_life_expectancy_static"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = local.thresholds["PageLifeExpectancyEvaluationPeriods"]
  metric_name               = "page-life-expectancy"
  namespace                 = local.namespace
  period                    = local.thresholds["PageLifeExpectancyPeriod"]
  statistic                 = "Average"
  threshold                 = local.thresholds["PageLifeExpectancyThreshold"]
  datapoints_to_alarm       = local.thresholds["PageLifeExpectancyDatapointsToAlarm"]
  alarm_description         = "The value of the Page life expectancy mssql counter as of this specific point in time."
  alarm_actions             = var.page_life_expectancy_static_actions_enabled == true ? [data.aws_sns_topic.notification_topic.arn] : null
  ok_actions                = var.page_life_expectancy_static_actions_enabled == true ? [data.aws_sns_topic.notification_topic.arn] : null
  insufficient_data_actions = var.page_life_expectancy_static_actions_enabled == true ? [data.aws_sns_topic.notification_topic.arn] : null
  treat_missing_data        = "breaching"
  tags                      = var.tags
  dimensions = {
    server_name = var.db_instance_id
  }
}

# LockWaitsPerSecond anomaly alarm
resource "aws_cloudwatch_metric_alarm" "page_life_expectancy_anomaly" {
  count                     = var.implement_anomaly_alarms && var.create_page_life_expectancy_anomaly ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.notification_topic.arn]
  alarm_description         = "PageLifeExpectancy anomaly detected."
  alarm_name                = "${var.db_instance_id}_page_life_expectancy_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["PageLifeExpectancyEvaluationPeriods"]
  datapoints_to_alarm       = local.thresholds["PageLifeExpectancyDatapointsToAlarm"]
  ok_actions                = var.page_life_expectancy_anomaly_actions_enabled == true ? [data.aws_sns_topic.notification_topic.arn] : null
  insufficient_data_actions = var.page_life_expectancy_anomaly_actions_enabled == true ? [data.aws_sns_topic.notification_topic.arn] : null
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "page-life-expectancy (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "page-life-expectancy"
      namespace   = local.namespace
      period      = local.thresholds["PageLifeExpectancyPeriod"]
      stat        = "Maximum"

      dimensions = {
        server_name = var.db_instance_id
      }
    }
  }
}
