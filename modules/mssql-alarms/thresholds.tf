locals {
  thresholds = {
    CPUUtilizationEvaluationPeriods                = min(max(var.cpu_utilization_evaluation_periods, 1), 10)
    CPUUtilizationThreshold                        = min(max(var.cpu_utilization_threshold, 1), 100)
    DatabaseConnectionsEvaluationPeriods           = min(max(var.db_connections_evaluation_periods, 1), 10)
    DatabaseConnectionsThreshold                   = min(max(var.db_connections_threshold, 1), 10000)
    DBLoadCPUEvaluationPeriods                     = min(max(var.db_load_cpu_evaluation_periods, 1), 10)
    DBLoadCPUThreshold                             = max(min(var.db_load_cpu_threshold, 10), 95)
    DBLoadCPUThreshold                             = max(min(var.db_load_cpu_threshold, 10), 95)
    DBLoadEvaluationPeriods                        = min(max(var.db_load_evaluation_periods, 1), 10)
    DBLoadNonCPUEvaluationPeriods                  = min(max(var.db_load_non_cpu_evaluation_periods, 1), 10)
    DBLoadNonCPUThreshold                          = max(min(var.db_load_non_cpu_threshold, 10), 95)
    DBLoadThreshold                                = min(max(var.db_load_threshold, 1), 95)
    DeadlocksPerSecondEvaluationPeriods            = min(max(var.deadlocks_per_second_evaluation_periods, 1), 10)
    DeadlocksPerSecondThreshold                    = max(min(var.deadlocks_per_second_threshold, 10), 100)
    DiskQueueDepthEvaluationPeriods                = min(max(var.disk_queue_depth_evaluation_periods, 1), 10)
    DiskQueueDepthThreshold                        = min(max(var.disk_queue_depth_threshold, 1), 100)
    FailedSQLServerAgentJobsCountEvaluationPeriods = min(max(var.failed_sql_server_agent_jobs_count_evaluation_periods, 1), 10)
    FailedSQLServerAgentJobsCountThreshold         = max(var.failed_sql_server_agent_jobs_count_threshold, 1)
    FreeableMemoryEvaluationPeriods                = min(max(var.freeable_memory_evaluation_periods, 1), 10)
    FreeableMemoryThreshold                        = min(max(var.freeable_memory_threshold, 1), 2147483648)
    FreeStorageSpaceEvaluationPeriods              = min(max(var.free_storage_space_evaluation_periods, 1), 10)
    FreeStorageSpaceThreshold                      = min(max(var.free_storage_space_threshold, 1), 2000000000)
    LockWaitsPerSecondEvaluationPeriods            = min(max(var.lock_waits_per_second_evaluation_periods, 1), 10)
    LockWaitsPerSecondThreshold                    = min(max(var.lock_waits_per_second_threshold, 1), 2000000000)
    NetworkReceiveThroughputEvaluationPeriods      = min(max(var.network_receive_throughput_evaluation_periods, 1), 10)
    NetworkTransmitThroughputEvaluationPeriods     = min(max(var.network_transmit_throughput_evaluation_periods, 1), 10)
    PageLifeExpectancyDatapointsToAlarm            = min(max(var.page_life_expectancy_datapoints_to_alarm, 1), 20)
    PageLifeExpectancyEvaluationPeriods            = min(max(var.page_life_expectancy_evaluation_periods, 1), 20)
    PageLifeExpectancyPeriod                       = min(max(var.page_life_expectancy_period, 1), 600)
    PageLifeExpectancyThreshold                    = min(max(var.page_life_expectancy_threshold, 1), 300)
    ReadIOPSEvaluationPeriods                      = min(max(var.read_iops_evaluation_periods, 1), 10)
    ReadIOPSThreshold                              = max(min(var.read_iops_threshold, 20000), 100000)
    ReadLatencyEvaluationPeriods                   = min(max(var.read_latency_evaluation_periods, 1), 10)
    ReadLatencyThreshold                           = min(var.read_latency_threshold, 30)
    ReadThroughputEvaluationPeriods                = min(max(var.read_throughput_evaluation_periods, 1), 10)
    RecompilationsPerSecondEvaluationPeriods       = min(max(var.recompilations_per_second_evaluation_periods, 1), 10)
    RecompilationsPerSecondThreshold               = min(var.recompilations_per_second_threshold, 500000)
    SwapUsageEvaluationPeriods                     = min(max(var.swap_usage_evaluation_periods, 1), 10)
    SwapUsageThreshold                             = min(var.swap_usage_threshold, 100000000) #100M
    TempDbAvailableDataSpaceEvaluationPeriods      = min(max(var.temp_db_available_data_space_evaluation_periods, 1), 10)
    TempDbAvailableDataSpaceThreshold              = min(max(var.temp_db_available_data_space_threshold, 1), 1000000000) #1G
    TempDbAvailableLogSpaceEvaluationPeriods       = min(max(var.temp_db_available_log_space_evaluation_periods, 1), 10)
    TempDbAvailableLogSpaceThreshold               = min(max(var.temp_db_available_log_space_threshold, 1), 1000000000) #1G
    TempDbDataFileUsageEvaluationPeriods           = min(max(var.temp_db_data_file_usage_evaluation_periods, 1), 10)
    TempDbDataFileUsageThreshold                   = min(max(var.temp_db_data_file_usage_threshold, 1), 100)
    TempDbLogFileUsageEvaluationPeriods            = min(max(var.temp_db_log_file_usage_evaluation_periods, 1), 10)
    TempDbLogFileUsageThreshold                    = min(max(var.temp_db_log_file_usage_threshold, 1), 100)
    WriteIOPSEvaluationPeriods                     = min(max(var.write_iops_evaluation_periods, 1), 10)
    WriteIOPSThreshold                             = max(min(var.write_iops_threshold, 100), 100000)
    WriteLatencyEvaluationPeriods                  = min(max(var.write_latency_evaluation_periods, 1), 10)
    WriteLatencyThreshold                          = max(min(var.write_latency_threshold, 1000), 100000)
    WriteThroughputEvaluationPeriods               = min(max(var.write_throughput_evaluation_periods, 1), 10)
  }
}