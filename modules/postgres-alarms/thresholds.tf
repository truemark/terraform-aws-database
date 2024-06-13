locals {
  thresholds = {

    # Each one of these static alarms has a default threshold.
    CheckpointLagEvaluationPeriods             = min(max(var.checkpoint_lag_evaluation_periods, 1), 10)
    CheckpointLagThreshold                     = min(var.checkpoint_lag_threshold, 600) # 10 minutes
    CPUUtilizationEvaluationPeriods            = min(var.cpu_utilization_evaluation_periods, 10)
    CPUUtilizationThreshold                    = min(max(var.cpu_utilization_threshold, 1), 100)
    DatabaseConnectionsEvaluationPeriods       = min(max(var.db_connections_evaluation_periods, 1), 10)
    DatabaseConnectionsThreshold               = max(var.db_connections_threshold, 1000)
    DiskQueueDepthEvaluationPeriods            = min(max(var.disk_queue_depth_evaluation_periods, 1), 10)
    DiskQueueDepthThreshold                    = min(var.disk_queue_depth_threshold, 100)
    FreeableMemoryEvaluationPeriods            = min(max(var.freeable_memory_evaluation_periods, 1), 10)
    FreeableMemoryThreshold                    = max(var.freeable_memory_threshold, 1000000000) #1G
    FreeStorageSpaceEvaluationPeriods          = min(max(var.free_storage_space_evaluation_periods, 1), 10)
    FreeStorageSpaceThreshold                  = max(var.free_storage_space_threshold, 2000000000) #2G
    LocalStoragePctEvaluationPeriods           = min(max(var.local_storage_pct_evaluation_periods, 1), 10)
    LocalStoragePctThreshold                   = max(var.local_storage_pct_threshold, 85)
    MaximumUsedTransactionIDsEvaluationPeriods = min(max(var.maximum_used_transaction_ids_evaluation_periods, 1), 10)
    MaximumUsedTransactionIDsThreshold         = min(var.maximum_used_transaction_ids_threshold, 500000000000)
    ReadIOPSEvaluationPeriods                  = min(max(var.read_iops_evaluation_periods, 1), 10)
    ReadIOPSThreshold                          = min(var.read_iops_threshold, 20000)
    ReadLatencyEvaluationPeriods               = min(max(var.read_latency_evaluation_periods, 1), 10)
    ReadLatencyThreshold                       = min(var.read_latency_threshold, 30)
    ReplicaLagEvaluationPeriods                = min(max(var.replica_lag_evaluation_periods, 1), 10)
    ReplicaLagThreshold                        = min(var.replica_lag_threshold, 300)
    SwapUsageEvaluationPeriods                 = min(max(var.swap_usage_evaluation_periods, 1), 10)
    SwapUsageThreshold                         = min(var.swap_usage_threshold, 100000000) #100M
    TransactionLogsDiskUsageEvaluationPeriods  = min(max(var.transaction_logs_disk_usage_evaluation_periods, 1), 10)
    TransactionLogsDiskUsageThreshold          = min(var.transaction_logs_disk_usage_threshold, 100000000000) #100G
    TransactionLogsGenerationEvaluationPeriods = min(max(var.transaction_logs_generation_evaluation_periods, 1), 10)
    TransactionLogsGenerationThreshold         = min(var.transaction_logs_generation_threshold, 500000000) # 500M
    WriteIOPSEvaluationPeriods                 = min(max(var.write_iops_evaluation_periods, 1), 10)
    WriteIOPSThreshold                         = min(var.write_iops_threshold, 20000)
    WriteLatencyEvaluationPeriods              = min(max(var.write_latency_evaluation_periods, 1), 10)
    WriteLatencyThreshold                      = min(var.write_latency_threshold, 30)

    # These are anomaly alarms. They do not have thresholds, as the model is the threshold.
    NetworkReceiveThroughputEvaluationPeriods  = min(max(var.network_receive_throughput_evaluation_periods, 1), 10)
    NetworkTransmitThroughputEvaluationPeriods = min(max(var.network_transmit_throughput_evaluation_periods, 1), 10)
    OldestReplicationSlotLagEvaluationPeriods  = min(max(var.oldest_replication_slot_lag_evaluation_periods, 1), 10)
    DBLoadCPUEvaluationPeriods                 = min(max(var.db_load_cpu_evaluation_periods, 1), 10)
    DBLoadEvaluationPeriods                    = min(max(var.db_load_evaluation_periods, 1), 10)
    DBLoadNonCPUEvaluationPeriods              = min(max(var.db_load_non_cpu_evaluation_periods, 1), 10)
    ReadThroughputEvaluationPeriods            = min(max(var.read_throughput_evaluation_periods, 1), 10)
    WriteThroughputEvaluationPeriods           = min(max(var.write_throughput_evaluation_periods, 1), 10)
  }
}
