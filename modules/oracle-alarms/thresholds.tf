locals {
  thresholds = {
    CPUUtilizationEvaluationPeriods    = min(max(var.cpu_utilization_evaluation_periods, 1), 100)
    CPUUtilizationThreshold            = min(max(var.cpu_utilization_threshold, 0), 100)
    DiskQueueDepthEvaluationPeriods    = min(max(var.disk_queue_depth_evaluation_periods, 1), 100)
    DiskQueueDepthThreshold            = max(var.disk_queue_depth_threshold, 0)
    FreeableMemoryEvaluationPeriods    = min(max(var.disk_queue_depth_evaluation_periods, 1), 100)
    FreeableMemoryThreshold            = max(var.freeable_memory_threshold, 0)
    PercentFreeMemoryEvaluationPeriods = min(max(var.percent_free_memory_evaluation_periods, 1), 100)
    PercentFreeMemoryThreshold         = min(max(var.percent_free_memory_threshold, 0), 100)
    FreeStorageSpaceThreshold          = max(var.free_storage_space_threshold, 0)
    FreeStorageSpaceEvaluationPeriods  = min(max(var.free_storage_space_evaluation_periods, 1), 100)
    SwapUsageThreshold                 = max(var.swap_usage_threshold, 0)
    SwapUsageEvaluationPeriods         = min(max(var.swap_usage_threshold, 1), 100)
  }
}