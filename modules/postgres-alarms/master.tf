#------------------------------------------------------------------------------
# Single Instance master threshold alarms
resource "aws_cloudwatch_metric_alarm" "master_cpu_utilization_high" {
  count                     = var.create_master_cpu_utilization_high_alarm ? 1 : 0
  alarm_name                = "${var.db_instance_id}_cpu_utilization_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["CPUUtilizationEvaluationPeriods"]
  metric_name               = "CPUUtilization"
  namespace                 = local.cloudwatch_namespace
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

resource "aws_cloudwatch_metric_alarm" "master_db_connections_high" {
  count                     = var.create_master_db_connections_high_alarm ? 1 : 0
  alarm_name                = "${var.db_instance_id}_db_connections_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["DatabaseConnectionsEvaluationPeriods"]
  metric_name               = "DatabaseConnections"
  namespace                 = local.cloudwatch_namespace
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["DatabaseConnectionsThreshold"]
  alarm_description         = "The number of db connections is high. Check db instance activity."
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  treat_missing_data        = "breaching"
  tags                      = var.tags
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "master_disk_queue_depth_high" {
  count                     = var.create_master_disk_queue_depth_high_alarm ? 1 : 0
  alarm_name                = "${var.db_instance_id}_disk_queue_depth_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["DiskQueueDepthEvaluationPeriods"]
  metric_name               = "DiskQueueDepth"
  namespace                 = local.cloudwatch_namespace
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

resource "aws_cloudwatch_metric_alarm" "master_freeable_memory_low" {
  count                     = var.create_master_freeable_memory_low_alarm ? 1 : 0
  alarm_name                = "${var.db_instance_id}_freeable_memory_low_static"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = local.thresholds["FreeableMemoryEvaluationPeriods"]
  metric_name               = "FreeableMemory"
  namespace                 = local.cloudwatch_namespace
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

resource "aws_cloudwatch_metric_alarm" "master_free_storage_space_low" {
  count               = var.create_master_free_storage_space_low_alarm ? 1 : 0
  alarm_name          = "${var.db_instance_id}_free_storage_space_low_static"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = local.thresholds["FreeStorageSpaceEvaluationPeriods"]
  metric_name         = "FreeStorageSpace"
  namespace           = local.cloudwatch_namespace
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

resource "aws_cloudwatch_metric_alarm" "master_swap_usage_high" {
  count                     = var.create_master_swap_usage_high_alarm ? 1 : 0
  alarm_name                = "${var.db_instance_id}_swap_usage_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["SwapUsageEvaluationPeriods"]
  metric_name               = "SwapUsage"
  namespace                 = local.cloudwatch_namespace
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

resource "aws_cloudwatch_metric_alarm" "master_local_storage_pct_low" {
  count                     = var.create_master_local_storage_pct_low_alarm ? 1 : 0
  alarm_name                = "${var.db_instance_id}_local_storage_pct_low_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["LocalStoragePctEvaluationPeriods"]
  metric_name               = "filesys-pct-used"
  namespace                 = "YL"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["LocalStoragePctThreshold"]
  alarm_description         = "Local storage percentage is very low. Check that autoscaling is not blocked."
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  treat_missing_data        = "breaching"
  dimensions = {
    rds-instance = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "master_checkpoint_lag_high" {
  count                     = var.create_master_checkpoint_lag_high_alarm ? 1 : 0
  alarm_name                = "${var.db_instance_id}_checkpoint_lag_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["CheckpointLagEvaluationPeriods"]
  metric_name               = "CheckpointLag"
  namespace                 = local.cloudwatch_namespace
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["CheckpointLagThreshold"]
  alarm_description         = "Average checkpoint lag high, replication may be affected."
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  treat_missing_data        = "breaching"
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "master_read_iops_high" {
  count                     = var.create_master_read_iops_high_alarm ? 1 : 0
  alarm_name                = "${var.db_instance_id}_read_iops_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["ReadIOPSEvaluationPeriods"]
  metric_name               = "ReadIOPS"
  namespace                 = local.cloudwatch_namespace
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["ReadIOPSThreshold"]
  alarm_description         = "Read IOPS above static threshold. Check db activity."
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  treat_missing_data        = "breaching"
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "master_write_iops_high" {
  count                     = var.create_master_write_iops_high_alarm ? 1 : 0
  alarm_name                = "${var.db_instance_id}_write_iops_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["WriteIOPSEvaluationPeriods"]
  metric_name               = "WriteIOPS"
  namespace                 = local.cloudwatch_namespace
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["WriteIOPSThreshold"]
  alarm_description         = "Write IOPS above static threshold. Check db activity."
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  treat_missing_data        = "breaching"
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "master_read_latency_high" {
  count                     = var.create_master_read_latency_high_alarm ? 1 : 0
  alarm_name                = "${var.db_instance_id}_read_latency_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["ReadLatencyEvaluationPeriods"]
  metric_name               = "ReadLatency"
  namespace                 = local.cloudwatch_namespace
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["ReadLatencyThreshold"]
  alarm_description         = "Read latency above static threshold. Check db activity."
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  treat_missing_data        = "breaching"
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "master_write_latency_high" {
  count                     = var.create_master_write_latency_high_alarm ? 1 : 0
  alarm_name                = "${var.db_instance_id}_write_latency_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["WriteLatencyEvaluationPeriods"]
  metric_name               = "WriteLatency"
  namespace                 = local.cloudwatch_namespace
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["WriteLatencyThreshold"]
  alarm_description         = "Write IOPS above static threshold. Check db activity."
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  treat_missing_data        = "breaching"
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "master_transaction_logs_disk_usage_high" {
  count                     = var.create_master_transaction_logs_disk_usage_high_alarm ? 1 : 0
  alarm_name                = "${var.db_instance_id}_transaction_logs_disk_usage_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["TransactionLogsDiskUsageEvaluationPeriods"]
  metric_name               = "TransactionLogsDiskUsage"
  namespace                 = local.cloudwatch_namespace
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["TransactionLogsDiskUsageThreshold"]
  alarm_description         = "TransactionLogsDiskUsage on local db server above static threshold. Check replication and storage autoextend config."
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  treat_missing_data        = "breaching"
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

# This metric is only valid on the master.
resource "aws_cloudwatch_metric_alarm" "master_transaction_logs_generation_high" {
  count                     = var.create_master_transaction_logs_generation_high_alarm ? 1 : 0
  alarm_name                = "${var.db_instance_id}_transaction_logs_generation_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["TransactionLogsGenerationEvaluationPeriods"]
  metric_name               = "TransactionLogsGeneration"
  namespace                 = local.cloudwatch_namespace
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["TransactionLogsGenerationThreshold"]
  alarm_description         = "TransactionLogsGeneration above static threshold. Check write activity."
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  treat_missing_data        = "breaching"
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "master_maximum_used_transaction_ids_high" {
  count                     = var.create_master_maximum_used_transaction_ids_high_alarm ? 1 : 0
  alarm_name                = "${var.db_instance_id}_maximum_used_transaction_ids_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["MaximumUsedTransactionIDsEvaluationPeriods"]
  metric_name               = "MaximumUsedTransactionIDs"
  namespace                 = local.cloudwatch_namespace
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["MaximumUsedTransactionIDsThreshold"]
  alarm_description         = "MaximumUsedTransactionIDs above static threshold. Check autovacuum settings and vacuum activity."
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  treat_missing_data        = "breaching"
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

#------------------------------------------------------------------------------
# Single Instance anomaly alarms.
# https://aws.amazon.com/blogs/database/best-practices-for-amazon-rds-postgresql-replication/

# WriteIOPS is valid on both master and replica
resource "aws_cloudwatch_metric_alarm" "master_write_iops" {
  count                     = var.create_anomaly_alarms && var.create_master_write_iops_anomaly_alarm ? 1 : 0
  actions_enabled           = false
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "WriteIOPS anomaly on master detected. Examine replication lag."
  alarm_name                = "${var.db_instance_id}_write_iops_master_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["WriteIOPSEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
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
      namespace   = local.cloudwatch_namespace
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# WriteThroughput is valid on both master and replica
resource "aws_cloudwatch_metric_alarm" "master_write_throughput" {
  count                     = var.create_anomaly_alarms && var.create_master_write_throughput_anomaly_alarm ? 1 : 0
  actions_enabled           = false
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "Write throughput anomaly on master detected. Examine replication lag."
  alarm_name                = "${var.db_instance_id}_write_throughput_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["WriteThroughputEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
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
      namespace   = local.cloudwatch_namespace
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# WriteLatency is valid on both master and replica
resource "aws_cloudwatch_metric_alarm" "master_write_latency" {
  count                     = var.create_anomaly_alarms && var.create_master_write_latency_anomaly_alarm ? 1 : 0
  actions_enabled           = false
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "Write throughput anomaly on master detected. Examine replication lag."
  alarm_name                = "${var.db_instance_id}_write_latency_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["WriteLatencyEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
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
      namespace   = local.cloudwatch_namespace
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# ReadIOPS is valid on both master and replica
resource "aws_cloudwatch_metric_alarm" "master_read_iops" {
  count                     = var.create_anomaly_alarms && var.create_master_read_iops_anomaly_alarm ? 1 : 0
  actions_enabled           = false
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "ReadIOPS anomaly on master detected. Examine replication lag."
  alarm_name                = "${var.db_instance_id}_read_iops_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["ReadIOPSEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
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
      namespace   = local.cloudwatch_namespace
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# ReadThroughput is valid on both master and replica
resource "aws_cloudwatch_metric_alarm" "master_read_throughput" {
  count                     = var.create_anomaly_alarms && var.create_master_read_throughput_anomaly_alarm ? 1 : 0
  actions_enabled           = false
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "Read throughput anomaly on master detected. Examine replication lag."
  alarm_name                = "${var.db_instance_id}_read_throughput_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["ReadThroughputEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
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
      namespace   = local.cloudwatch_namespace
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# ReadLatency is valid on both master and replica
resource "aws_cloudwatch_metric_alarm" "master_read_latency" {
  count                     = var.create_anomaly_alarms && var.create_master_read_latency_anomaly_alarm ? 1 : 0
  actions_enabled           = false
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "Read latency anomaly on master detected. Examine replication lag."
  alarm_name                = "${var.db_instance_id}_read_latency_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["ReadLatencyEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
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
      namespace   = local.cloudwatch_namespace
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# DBLoadCPU master anomaly alarm
resource "aws_cloudwatch_metric_alarm" "master_db_load_cpu" {
  count                     = var.create_anomaly_alarms && var.create_master_db_load_cpu_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "DBLoadCPU anomaly on master detected. Examine replication lag."
  alarm_name                = "${var.db_instance_id}_db_load_cpu_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["DBLoadCPUEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "DBLoadCPU (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "DBLoadCPU"
      namespace   = local.cloudwatch_namespace
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# DBLoadNonCPU replica anomaly alarm
resource "aws_cloudwatch_metric_alarm" "master_db_load_non_cpu" {
  count                     = var.create_anomaly_alarms && var.create_master_db_load_non_cpu_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "DBLoadNonCPU anomaly on master detected. Examine replication lag."
  alarm_name                = "${var.db_instance_id}_db_load_non_cpu_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["DBLoadNonCPUEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "DBLoadNonCPU (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "DBLoadNonCPU"
      namespace   = local.cloudwatch_namespace
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# DBLoad master anomaly alarm
resource "aws_cloudwatch_metric_alarm" "master_db_load" {
  count                     = var.create_anomaly_alarms && var.create_master_db_load_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "DBLoad anomaly on master detected. Examine replication lag."
  alarm_name                = "${var.db_instance_id}_db_load_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["DBLoadEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "DBLoad (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "DBLoad"
      namespace   = local.cloudwatch_namespace
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# CheckpointLag master anomaly alarm
resource "aws_cloudwatch_metric_alarm" "master_checkpoint_lag" {
  count                     = var.create_anomaly_alarms && var.create_master_checkpoint_lag_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "CheckpointLag anomaly on master detected. Examine replication lag."
  alarm_name                = "${var.db_instance_id}_checkpoint_lag_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["CheckpointLagEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "CheckpointLag (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "CheckpointLag"
      namespace   = local.cloudwatch_namespace
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# CPUUtilization anomaly alarm
resource "aws_cloudwatch_metric_alarm" "master_cpu_utilization_anomaly" {
  count                     = var.create_anomaly_alarms && var.create_master_cpu_utilization_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "CPUUtilization anomaly detected."
  alarm_name                = "${var.db_instance_id}_cpu_utilization_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["CPUUtilizationEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "CPUUtilization (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "CPUUtilization"
      namespace   = local.cloudwatch_namespace
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# OldestReplicationSlotLag master anomaly alarm only valid on master
resource "aws_cloudwatch_metric_alarm" "master_oldest_replication_slot_lag" {
  count                     = var.create_anomaly_alarms && var.create_master_oldest_replication_slot_lag_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = var.anomaly_actions_enabled ? [data.aws_sns_topic.topic.arn] : []
  alarm_description         = "OldestReplicationSlotLag anomaly on master detected. Examine replication lag."
  alarm_name                = "${var.db_instance_id}_oldest_replication_slot_lag_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["OldestReplicationSlotLagEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "OldestReplicationSlotLag (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "OldestReplicationSlotLag"
      namespace   = local.cloudwatch_namespace
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# DatabaseConnections master anomaly alarm
resource "aws_cloudwatch_metric_alarm" "master_db_connections" {
  count                     = var.create_anomaly_alarms && var.create_master_db_connections_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "DatabaseConnections anomaly on master detected. Examine replication lag."
  alarm_name                = "${var.db_instance_id}_db_connections_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["DatabaseConnectionsEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "DatabaseConnections (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "DatabaseConnections"
      namespace   = local.cloudwatch_namespace
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# FreeableMemory master anomaly alarm
resource "aws_cloudwatch_metric_alarm" "master_freeable_memory" {
  count                     = var.create_anomaly_alarms && var.create_master_freeable_memory_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "FreeableMemory anomaly on master detected. Examine replication lag."
  alarm_name                = "${var.db_instance_id}_freeable_memory_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["FreeableMemoryEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "FreeableMemory (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "FreeableMemory"
      namespace   = local.cloudwatch_namespace
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# SwapUsage master anomaly alarm
resource "aws_cloudwatch_metric_alarm" "master_swap_usage" {
  count                     = var.create_anomaly_alarms && var.create_master_swap_usage_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "SwapUsage anomaly on master detected. Examine replication lag."
  alarm_name                = "${var.db_instance_id}_swap_usage_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["SwapUsageEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
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
      namespace   = local.cloudwatch_namespace
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# FreeStorageSpace master anomaly alarm
resource "aws_cloudwatch_metric_alarm" "master_free_storage_space" {
  count                     = var.create_anomaly_alarms && var.create_master_free_storage_space_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "FreeStorageSpace anomaly on master detected. Examine replication lag."
  alarm_name                = "${var.db_instance_id}_free_storage_space_anomaly"
  comparison_operator       = "LessThanLowerThreshold"
  evaluation_periods        = local.thresholds["FreeStorageSpaceEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "FreeStorageSpace (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "FreeStorageSpace"
      namespace   = local.cloudwatch_namespace
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# DiskQueueDepth master anomaly alarm
resource "aws_cloudwatch_metric_alarm" "master_disk_queue_depth" {
  count                     = var.create_anomaly_alarms && var.create_master_disk_queue_depth_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "DiskQueueDepth anomaly on master detected. Examine replication lag."
  alarm_name                = "${var.db_instance_id}_disk_queue_depth_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["DiskQueueDepthEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "DiskQueueDepth (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "DiskQueueDepth"
      namespace   = local.cloudwatch_namespace
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# NetworkTransmitThroughput master anomaly alarm
resource "aws_cloudwatch_metric_alarm" "master_network_transmit_throughput" {
  count                     = var.create_anomaly_alarms && var.create_master_network_transmit_throughput_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "NetworkTransmitThroughput anomaly on master detected. Examine replication lag."
  alarm_name                = "${var.db_instance_id}_network_transmit_throughput_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["NetworkTransmitThroughputEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
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
      namespace   = local.cloudwatch_namespace
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# NetworkReceiveThroughput master anomaly alarm
resource "aws_cloudwatch_metric_alarm" "master_network_receive_throughput" {
  count                     = var.create_anomaly_alarms && var.create_master_network_receive_throughput_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "NetworkReceiveThroughput anomaly on master detected. Examine replication lag."
  alarm_name                = "${var.db_instance_id}_network_receive_throughput_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["NetworkReceiveThroughputEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
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
      namespace   = local.cloudwatch_namespace
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# TransactionLogsGeneration master anomaly alarm
resource "aws_cloudwatch_metric_alarm" "master_transaction_logs_generation" {
  count                     = var.create_anomaly_alarms && var.create_master_transaction_logs_generation_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "TransactionLogsGeneration anomaly on master detected. Examine replication lag."
  alarm_name                = "${var.db_instance_id}_transaction_logs_generation_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["TransactionLogsGenerationEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "TransactionLogsGeneration (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "TransactionLogsGeneration"
      namespace   = local.cloudwatch_namespace
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}
