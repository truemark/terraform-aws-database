locals {
  create_replica = var.replica_db_instance_id != "" ? true : false
}

#------------------------------------------------------------------------------
# Single instance replica threshold alarms
resource "aws_cloudwatch_metric_alarm" "replica_cpu_utilization_high" {
  count                     = local.create_replica && var.create_replica_cpu_utilization_high_alarm ? 1 : 0
  alarm_name                = "${var.replica_db_instance_id}_cpu_utilization_high_static"
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
    DBInstanceIdentifier = var.replica_db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "replica_db_connections_high" {
  count                     = local.create_replica && var.create_replica_db_connections_high_alarm ? 1 : 0
  alarm_name                = "${var.replica_db_instance_id}_db_connections_high_static"
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
    DBInstanceIdentifier = var.replica_db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "replica_disk_queue_depth_high" {
  count                     = local.create_replica && var.create_replica_disk_queue_depth_high_alarm ? 1 : 0
  alarm_name                = "${var.replica_db_instance_id}_disk_queue_depth_high_static"
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
    DBInstanceIdentifier = var.replica_db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "replica_freeable_memory_low" {
  count                     = local.create_replica && var.create_replica_freeable_memory_low_alarm ? 1 : 0
  alarm_name                = "${var.replica_db_instance_id}_freeable_memory_low_static"
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
    DBInstanceIdentifier = var.replica_db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "replica_free_storage_space_low" {
  count               = local.create_replica && var.create_replica_free_storage_space_low_alarm ? 1 : 0
  alarm_name          = "${var.replica_db_instance_id}_free_storage_space_low_static"
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
    DBInstanceIdentifier = var.replica_db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "replica_swap_usage_high" {
  count                     = local.create_replica && var.create_replica_swap_usage_high_alarm ? 1 : 0
  alarm_name                = "${var.replica_db_instance_id}_swap_usage_high_static"
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
    DBInstanceIdentifier = var.replica_db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "replica_local_storage_pct_low" {
  count                     = local.create_replica && var.create_replica_local_storage_pct_low_alarm ? 1 : 0
  alarm_name                = "${var.replica_db_instance_id}_local_storage_pct_low_static"
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
    rds-instance = var.replica_db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "replica_lag_high" {
  count                     = local.create_replica && var.create_replica_lag_high_alarm ? 1 : 0
  alarm_name                = "${var.replica_db_instance_id}_lag_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["ReplicaLagEvaluationPeriods"]
  metric_name               = "ReplicaLag"
  namespace                 = local.cloudwatch_namespace
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["ReplicaLagThreshold"]
  alarm_description         = "Average replica lag high. Replication may be affected."
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  treat_missing_data        = "breaching"
  dimensions = {
    DBInstanceIdentifier = var.replica_db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "replica_read_iops_high" {
  count                     = local.create_replica && var.create_replica_read_iops_high_alarm ? 1 : 0
  alarm_name                = "${var.replica_db_instance_id}_read_iops_high_static"
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
    DBInstanceIdentifier = var.replica_db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "replica_write_iops_high" {
  count                     = local.create_replica && var.create_replica_write_iops_high_alarm ? 1 : 0
  alarm_name                = "${var.replica_db_instance_id}_write_iops_high_static"
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
    DBInstanceIdentifier = var.replica_db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "replica_read_latency_high" {
  count                     = local.create_replica && var.create_replica_read_latency_high_alarm ? 1 : 0
  alarm_name                = "${var.replica_db_instance_id}_read_latency_high_static"
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
    DBInstanceIdentifier = var.replica_db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "replica_write_latency_high" {
  count                     = local.create_replica && var.create_replica_write_latency_high_alarm ? 1 : 0
  alarm_name                = "${var.replica_db_instance_id}_write_latency_high_static"
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
    DBInstanceIdentifier = var.replica_db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "replica_transaction_logs_disk_usage_high" {
  count                     = local.create_replica && var.create_replica_transaction_logs_disk_usage_high_alarm ? 1 : 0
  alarm_name                = "${var.replica_db_instance_id}_transaction_logs_disk_usage_high_static"
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
    DBInstanceIdentifier = var.replica_db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "replica_maximum_used_transaction_ids_high" {
  count                     = local.create_replica && var.create_replica_maximum_used_transaction_ids_high_alarm ? 1 : 0
  alarm_name                = "${var.replica_db_instance_id}_maximum_used_transaction_ids_high_static"
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
    DBInstanceIdentifier = var.replica_db_instance_id
  }
}

#------------------------------------------------------------------------------
# Single Instance anomaly alarms
# WriteIOPS is valid on both master and replica
resource "aws_cloudwatch_metric_alarm" "replica_write_iops" {
  count                     = var.create_anomaly_alarms && var.create_replica_write_iops_anomaly_alarm ? 1 : 0
  actions_enabled           = false
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "WriteIOPS anomaly on replica detected. Examine replication lag."
  alarm_name                = "${var.replica_db_instance_id}_write_iops_anomaly"
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
        DBInstanceIdentifier = var.replica_db_instance_id
      }
    }
  }
}

# WriteThroughput is valid on both master and replica
resource "aws_cloudwatch_metric_alarm" "replica_write_throughput" {
  count                     = var.create_anomaly_alarms && var.create_replica_write_throughput_anomaly_alarm ? 1 : 0
  actions_enabled           = false
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "Write throughput anomaly on replica detected. Examine replication lag."
  alarm_name                = "${var.replica_db_instance_id}_write_throughput_anomaly"
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
        DBInstanceIdentifier = var.replica_db_instance_id
      }
    }
  }
}

# WriteLatency is valid on both master and replica
resource "aws_cloudwatch_metric_alarm" "replica_write_latency" {
  count                     = var.create_anomaly_alarms && var.create_replica_write_latency_anomaly_alarm ? 1 : 0
  actions_enabled           = false
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "Write throughput anomaly on replica detected. Examine replication lag."
  alarm_name                = "${var.replica_db_instance_id}_write_latency_anomaly"
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
        DBInstanceIdentifier = var.replica_db_instance_id
      }
    }
  }
}

# ReadIOPS is valid on both master and replica
resource "aws_cloudwatch_metric_alarm" "replica_read_iops" {
  count                     = var.create_anomaly_alarms && var.create_replica_read_iops_anomaly_alarm ? 1 : 0
  actions_enabled           = false
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "ReadIOPS anomaly on replica detected. Examine replication lag."
  alarm_name                = "${var.replica_db_instance_id}_read_iops_anomaly"
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
        DBInstanceIdentifier = var.replica_db_instance_id
      }
    }
  }
}

# ReadThroughput is valid on both master and replica
resource "aws_cloudwatch_metric_alarm" "replica_read_throughput" {
  count                     = local.create_replica && var.create_replica_read_throughput_anomaly_alarm ? 1 : 0
  actions_enabled           = false
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "Read throughput anomaly on replica detected. Examine replication lag."
  alarm_name                = "${var.replica_db_instance_id}_read_throughput"
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
        DBInstanceIdentifier = var.replica_db_instance_id
      }
    }
  }
}

# ReadLatency is valid on both master and replica
resource "aws_cloudwatch_metric_alarm" "replica_read_latency" {
  count                     = var.create_anomaly_alarms && var.create_replica_read_latency_anomaly_alarm ? 1 : 0
  actions_enabled           = false
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "Read latency anomaly on replica detected. Examine replication lag."
  alarm_name                = "${var.replica_db_instance_id}_read_latency_anomaly"
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
        DBInstanceIdentifier = var.replica_db_instance_id
      }
    }
  }
}

# DBLoadCPU replica anomaly alarm
resource "aws_cloudwatch_metric_alarm" "replica_db_load_cpu" {
  count                     = var.create_anomaly_alarms && var.create_replica_db_load_cpu_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "DBLoadCPU anomaly on replica detected. Examine replication lag."
  alarm_name                = "${var.replica_db_instance_id}_db_load_cpu_anomaly"
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
        DBInstanceIdentifier = var.replica_db_instance_id
      }
    }
  }
}

# DBLoadNonCPU replica anomaly alarm
resource "aws_cloudwatch_metric_alarm" "replica_db_load_non_cpu" {
  count                     = var.create_anomaly_alarms && var.create_replica_db_load_non_cpu_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "DBLoadNonCPU anomaly on replica detected. Examine replication lag."
  alarm_name                = "${var.replica_db_instance_id}_db_load_non_cpu_anomaly"
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
        DBInstanceIdentifier = var.replica_db_instance_id
      }
    }
  }
}

# DBLoad replica anomaly alarm
resource "aws_cloudwatch_metric_alarm" "replica_db_load" {
  count                     = var.create_anomaly_alarms && var.create_replica_db_load_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "DBLoad anomaly on replica detected. Examine replication lag."
  alarm_name                = "${var.replica_db_instance_id}_db_load_anomaly"
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
        DBInstanceIdentifier = var.replica_db_instance_id
      }
    }
  }
}

# CheckpointLag replica anomaly alarm
resource "aws_cloudwatch_metric_alarm" "replica_checkpoint_lag" {
  count                     = var.create_anomaly_alarms && var.create_replica_checkpoint_lag_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "CheckpointLag anomaly on replica detected. Examine replication lag."
  alarm_name                = "${var.replica_db_instance_id}_checkpoint_lag_anomaly"
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
        DBInstanceIdentifier = var.replica_db_instance_id
      }
    }
  }
}

# CPUUtilization anomaly alarm
resource "aws_cloudwatch_metric_alarm" "replica_cpu_utilization_anomaly" {
  count                     = var.create_anomaly_alarms && var.create_replica_cpu_utilization_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "CPUUtilization anomaly detected."
  alarm_name                = "${var.db_instance_id}_replica_cpu_utilization_anomaly"
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

# DatabaseConnections anomaly alarm
resource "aws_cloudwatch_metric_alarm" "replica_db_connections_anomaly" {
  count                     = var.create_anomaly_alarms && var.create_replica_db_connections_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "DatabaseConnections anomaly detected."
  alarm_name                = "${var.db_instance_id}_replica_db_connections_anomaly"
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

# DBLoad anomaly alarm
resource "aws_cloudwatch_metric_alarm" "replica_db_load_anomaly" {
  count                     = var.create_anomaly_alarms && var.create_replica_db_load_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "DBLoad anomaly detected."
  alarm_name                = "${var.db_instance_id}_replica_db_load_anomaly"
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

# DBLoadCPU anomaly alarm
resource "aws_cloudwatch_metric_alarm" "replica_db_load_cpu_anomaly" {
  count                     = var.create_anomaly_alarms && var.create_replica_db_load_cpu_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "DBLoadCPU anomaly detected."
  alarm_name                = "${var.db_instance_id}_replica_db_load_cpu_anomaly"
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

# DBLoadNonCPU anomaly alarm
resource "aws_cloudwatch_metric_alarm" "replica_db_non_load_cpu_anomaly" {
  count                     = var.create_anomaly_alarms && var.create_replica_db_non_load_cpu_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "DBLoadNonCPU anomaly detected."
  alarm_name                = "${var.db_instance_id}_replica_db_non_load_cpu_anomaly"
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

# DiskQueueDepth anomaly alarm
resource "aws_cloudwatch_metric_alarm" "replica_disk_queue_depth_anomaly" {
  count                     = var.create_anomaly_alarms && var.create_replica_disk_queue_depth_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "DiskQueueDepth anomaly detected."
  alarm_name                = "${var.db_instance_id}_replica_disk_queue_depth_cpu_anomaly"
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

# FreeableMemory anomaly alarm
resource "aws_cloudwatch_metric_alarm" "replica_freeable_memory_anomaly" {
  count                     = var.create_anomaly_alarms && var.create_replica_freeable_memory_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "FreeableMemory anomaly detected."
  alarm_name                = "${var.db_instance_id}_replica_freeable_memory_anomaly"
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

# FreeStorageSpace anomaly alarm
resource "aws_cloudwatch_metric_alarm" "replica_free_storage_space_anomaly" {
  count                     = var.create_anomaly_alarms && var.create_replica_free_storage_space_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "FreeStorageSpace anomaly detected."
  alarm_name                = "${var.db_instance_id}_replica_free_storage_space_anomaly"
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

# MaximumUsedTransactionIDs anomaly alarm
resource "aws_cloudwatch_metric_alarm" "replica_maximum_used_transaction_ids" {
  count                     = var.create_anomaly_alarms && var.create_replica_maximum_used_transaction_ids_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "MaximumUsedTransactionIDs anomaly detected."
  alarm_name                = "${var.db_instance_id}_replica_maximum_used_transaction_ids_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["MaximumUsedTransactionIDsEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "MaximumUsedTransactionIDs (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "MaximumUsedTransactionIDs"
      namespace   = local.cloudwatch_namespace
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# NetworkReceiveThroughput anomaly alarm
resource "aws_cloudwatch_metric_alarm" "replica_network_receive_throughput_anomaly" {
  count                     = var.create_anomaly_alarms && var.create_replica_network_receive_throughput_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "NetworkReceiveThroughput anomaly detected."
  alarm_name                = "${var.db_instance_id}_replica_network_receive_throughput_anomaly"
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

# NetworkTransmitThroughput anomaly alarm
resource "aws_cloudwatch_metric_alarm" "replica_network_transmit_throughput_anomaly" {
  count                     = var.create_anomaly_alarms && var.create_replica_network_transmit_throughput_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "NetworkTransmitThroughput anomaly detected."
  alarm_name                = "${var.db_instance_id}_replica_network_transmit_throughput_anomaly"
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

# ReadIOPS anomaly alarm
resource "aws_cloudwatch_metric_alarm" "replica_read_iops_anomaly" {
  count                     = var.create_anomaly_alarms && var.create_replica_read_iops_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "ReadIOPS anomaly detected."
  alarm_name                = "${var.db_instance_id}_replica_read_iops_anomaly"
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

# ReadLatency anomaly alarm
resource "aws_cloudwatch_metric_alarm" "replica_read_latency_anomaly" {
  count                     = var.create_anomaly_alarms && var.create_replica_read_latency_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "ReadLatency anomaly detected."
  alarm_name                = "${var.db_instance_id}_replica_read_latency_anomaly"
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

# ReadThroughput anomaly alarm
resource "aws_cloudwatch_metric_alarm" "replica_read_throughput_anomaly" {
  count                     = var.create_anomaly_alarms && var.create_replica_read_throughput_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "ReadThroughput anomaly detected."
  alarm_name                = "${var.db_instance_id}_replica_read_throughput_anomaly"
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

# SwapUsage anomaly alarm
resource "aws_cloudwatch_metric_alarm" "replica_swap_usage_anomaly" {
  count                     = var.create_anomaly_alarms && var.create_replica_swap_usage_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "SwapUsage anomaly detected."
  alarm_name                = "${var.db_instance_id}_replica_swap_usage_anomaly"
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

# TransactionLogsGeneration anomaly alarm
resource "aws_cloudwatch_metric_alarm" "replica_transaction_logs_generation_anomaly" {
  count                     = var.create_anomaly_alarms && var.create_replica_transaction_logs_generation_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "TransactionLogsGeneration anomaly detected."
  alarm_name                = "${var.db_instance_id}_replica_transaction_logs_generation_anomaly"
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

# TransactionLogsDiskUsage anomaly alarm
resource "aws_cloudwatch_metric_alarm" "replica_transaction_logs_disk_usage_anomaly" {
  count                     = var.create_anomaly_alarms && var.create_replica_transaction_logs_disk_usage_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "TransactionLogsDiskUsage anomaly detected."
  alarm_name                = "${var.db_instance_id}_replica_transaction_logs_disk_usage_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["TransactionLogsDiskUsageEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "TransactionLogsDiskUsage (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "TransactionLogsDiskUsage"
      namespace   = local.cloudwatch_namespace
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# WriteIOPS anomaly alarm
resource "aws_cloudwatch_metric_alarm" "replica_write_iops_anomaly" {
  count                     = var.create_anomaly_alarms && var.create_replica_write_iops_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "WriteIOPS anomaly detected."
  alarm_name                = "${var.db_instance_id}_replica_write_iops_anomaly"
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

# WriteLatency anomaly alarm
resource "aws_cloudwatch_metric_alarm" "replica_write_latency_anomaly" {
  count                     = var.create_anomaly_alarms && var.create_replica_write_latency_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "WriteLatency anomaly detected."
  alarm_name                = "${var.db_instance_id}_replica_write_latency_anomaly"
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

# WriteThroughput anomaly alarm
resource "aws_cloudwatch_metric_alarm" "replica_write_throughput_anomaly" {
  count                     = var.create_anomaly_alarms && var.create_replica_write_throughput_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "WriteThroughput anomaly detected."
  alarm_name                = "${var.db_instance_id}_replica_write_throughput_anomaly"
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

resource "aws_cloudwatch_metric_alarm" "replica_checkpoint_lag_high" {
  count                     = local.create_replica && var.create_replica_checkpoint_lag_high_alarm ? 1 : 0
  alarm_name                = "${var.db_instance_id}_replica_checkpoint_lag_high_static"
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
    DBInstanceIdentifier = var.replica_db_instance_id
  }
}

# OldestReplicationSlotLag replica anomaly alarm
resource "aws_cloudwatch_metric_alarm" "replica_oldest_replication_slot_lag" {
  count                     = var.create_anomaly_alarms && var.create_replica_oldest_replication_slot_lag_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "OldestReplicationSlotLag anomaly on replica detected. Examine replication lag."
  alarm_name                = "${var.replica_db_instance_id}_oldest_replication_slot_lag_anomaly"
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
        DBInstanceIdentifier = var.replica_db_instance_id
      }
    }
  }
}

# DatabaseConnections replica anomaly alarm
resource "aws_cloudwatch_metric_alarm" "replica_db_connections" {
  count                     = var.create_anomaly_alarms && var.create_replica_db_connections_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "DatabaseConnections anomaly on replica detected. Examine replication lag."
  alarm_name                = "${var.replica_db_instance_id}_db_connections_anomaly"
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
        DBInstanceIdentifier = var.replica_db_instance_id
      }
    }
  }
}

# FreeableMemory replica anomaly alarm
resource "aws_cloudwatch_metric_alarm" "replica_freeable_memory" {
  count                     = var.create_anomaly_alarms && var.create_replica_freeable_memory_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "FreeableMemory anomaly on replica detected. Examine replication lag."
  alarm_name                = "${var.replica_db_instance_id}_freeable_memory_anomaly"
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
        DBInstanceIdentifier = var.replica_db_instance_id
      }
    }
  }
}

# SwapUsage replica anomaly alarm
resource "aws_cloudwatch_metric_alarm" "replica_swap_usage" {
  count                     = var.create_anomaly_alarms && var.create_replica_swap_usage_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "SwapUsage anomaly on replica detected. Examine replication lag."
  alarm_name                = "${var.replica_db_instance_id}_swap_usage_anomaly"
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
        DBInstanceIdentifier = var.replica_db_instance_id
      }
    }
  }
}

# FreeStorageSpace replica anomaly alarm
resource "aws_cloudwatch_metric_alarm" "replica_free_storage_space" {
  count                     = var.create_anomaly_alarms && var.create_replica_free_storage_space_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "FreeStorageSpace anomaly on replica detected. Examine replication lag."
  alarm_name                = "${var.replica_db_instance_id}_free_storage_space_anomaly"
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
        DBInstanceIdentifier = var.replica_db_instance_id
      }
    }
  }
}

# DiskQueueDepth replica anomaly alarm
resource "aws_cloudwatch_metric_alarm" "replica_disk_queue_depth" {
  count                     = var.create_anomaly_alarms && var.create_replica_disk_queue_depth_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "DiskQueueDepth anomaly on replica detected. Examine replication lag."
  alarm_name                = "${var.replica_db_instance_id}_disk_queue_depth_anomaly"
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
        DBInstanceIdentifier = var.replica_db_instance_id
      }
    }
  }
}

# NetworkTransmitThroughput replica anomaly alarm
resource "aws_cloudwatch_metric_alarm" "replica_network_transmit_throughput" {
  count                     = var.create_anomaly_alarms && var.create_replica_network_transmit_throughput_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "NetworkTransmitThroughput anomaly on replica detected. Examine replication lag."
  alarm_name                = "${var.replica_db_instance_id}_network_transmit_throughput_anomaly"
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
        DBInstanceIdentifier = var.replica_db_instance_id
      }
    }
  }
}

# NetworkReceiveThroughput replica anomaly alarm
resource "aws_cloudwatch_metric_alarm" "replica_network_receive_throughput" {
  count                     = var.create_anomaly_alarms && var.create_replica_network_receive_throughput_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "NetworkReceiveThroughput anomaly on replica detected. Examine replication lag."
  alarm_name                = "${var.replica_db_instance_id}_network_receive_throughput_anomaly"
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
        DBInstanceIdentifier = var.replica_db_instance_id
      }
    }
  }
}

# TransactionLogsGeneration replica anomaly alarm
resource "aws_cloudwatch_metric_alarm" "replica_transaction_logs_generation" {
  count                     = var.create_anomaly_alarms && var.create_replica_transaction_logs_generation_anomaly_alarm ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "TransactionLogsGeneration anomaly on replica detected. Examine replication lag."
  alarm_name                = "${var.replica_db_instance_id}_transaction_logs_generation_anomaly"
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
        DBInstanceIdentifier = var.replica_db_instance_id
      }
    }
  }
}
