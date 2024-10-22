variable "anomaly_actions_enabled" {
  description = "Switch to enable anomaly actions (notifications). Default is false."
  type        = bool
  default     = false
}

variable "checkpoint_lag_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "checkpoint_lag_threshold" {
  description = "Value in seconds that will trigger a checkpoint value alarm."
  type        = number
  default     = 600 # 10 minutes
}

variable "cpu_utilization_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "cpu_utilization_threshold" {
  description = "The maximum percentage of CPU utilization."
  type        = number
  default     = 90
}

variable "create_anomaly_alarms" {
  description = "Toggle to turn off all anomaly alarms."
  type        = bool
  default     = true
}

variable "create_master_checkpoint_lag_anomaly_alarm" {
  description = "Toggle to create <alarm name>"
  type        = bool
  default     = true
}

variable "create_master_checkpoint_lag_high_alarm" {
  description = "Toggle to create <alarm name>"
  type        = bool
  default     = true
}

variable "create_master_cpu_utilization_anomaly_alarm" {
  description = "Toggle to create master_cpu_utilization_anomaly alarm."
  type        = bool
  default     = true
}

variable "create_master_cpu_utilization_high_alarm" {
  description = "Toggle to create master_cpu_utilization_high alarm."
  type        = bool
  default     = true
}

variable "create_master_db_connections_anomaly_alarm" {
  description = "Toggle to create <alarm name>"
  type        = bool
  default     = true
}

variable "create_master_db_connections_high_alarm" {
  description = "Toggle to create master_db_connections_high alarm."
  type        = bool
  default     = true
}

variable "create_master_db_load_anomaly_alarm" {
  description = "Toggle to create master_db_load_anomaly alarm."
  type        = bool
  default     = true
}

variable "create_master_db_load_high_alarm" {
  description = "Toggle to create master_db_load_high alarm."
  type        = bool
  default     = true
}

variable "create_master_db_load_cpu_anomaly_alarm" {
  description = "Toggle to create master_db_load_cpu_anomaly alarm."
  type        = bool
  default     = true
}

variable "create_master_db_load_cpu_high_alarm" {
  description = "Toggle to create master_db_load_cpu_high alarm."
  type        = bool
  default     = true
}

variable "create_master_db_load_non_cpu_anomaly_alarm" {
  description = "Toggle to create master_db_load_non_cpu_anomaly alarm."
  type        = bool
  default     = true
}

variable "create_master_db_load_non_cpu_high_alarm" {
  description = "Toggle to create master_db_load_non_cpu_high alarm."
  type        = bool
  default     = true
}

variable "create_master_disk_queue_depth_anomaly_alarm" {
  description = "Toggle to create master_disk_queue_depth_anomaly alarm."
  type        = bool
  default     = true
}

variable "create_master_disk_queue_depth_high_alarm" {
  description = "Toggle to create disk_queue_depth_high alarm."
  type        = bool
  default     = true
}

variable "create_master_free_storage_space_anomaly_alarm" {
  description = "Toggle to create master_free_storage_space_anomaly alarm."
  type        = bool
  default     = true
}

variable "create_master_free_storage_space_low_alarm" {
  description = "Toggle to create master_free_storage_space_low alarm."
  type        = bool
  default     = true
}

variable "create_master_freeable_memory_anomaly_alarm" {
  description = "Toggle to create master_freeable_memory_anomaly alarm."
  type        = bool
  default     = true
}

variable "create_master_freeable_memory_low_alarm" {
  description = "Toggle to create master_freeable_memory_low alarm."
  type        = bool
  default     = true
}

variable "create_master_local_storage_pct_low_alarm" {
  description = "Toggle to create master_local_storage_pct_low alarm."
  type        = bool
  default     = true
}

variable "create_master_maximum_used_transaction_ids_high_alarm" {
  description = "Toggle to create maximum_used_transaction_ids_high alarm."
  type        = bool
  default     = true
}

variable "create_master_network_receive_throughput_anomaly_alarm" {
  description = "Toggle to create master_network_receive_throughput_anomaly alarm."
  type        = bool
  default     = true
}

variable "create_master_network_transmit_throughput_anomaly_alarm" {
  description = "Toggle to create master_network_transmit_throughput_anomaly alarm."
  type        = bool
  default     = true
}

variable "create_master_oldest_replication_slot_lag_anomaly_alarm" {
  description = "Toggle to createmaster_oldest_replication_slot_lag_anomaly alarm."
  type        = bool
  default     = true
}

variable "create_master_read_iops_anomaly_alarm" {
  description = "Toggle to create master_read_iops_anomaly alarm."
  type        = bool
  default     = true
}

variable "create_master_read_iops_high_alarm" {
  description = "Toggle to create master_read_iops_high_alarm alarm."
  type        = bool
  default     = true
}

variable "create_master_read_latency_anomaly_alarm" {
  description = "Toggle to create _master_read_latency_anomaly_alarm alarm."
  type        = bool
  default     = true
}

variable "create_master_read_latency_high_alarm" {
  description = "Toggle to create master_read_latency_high alarm."
  type        = bool
  default     = true
}

variable "create_master_read_throughput_anomaly_alarm" {
  description = "Toggle to create master_read_throughput_anomaly alarm."
  type        = bool
  default     = true
}

variable "create_master_swap_usage_anomaly_alarm" {
  description = "Toggle to create master_swap_usage_anomaly alarm."
  type        = bool
  default     = true
}

variable "create_master_swap_usage_high_alarm" {
  description = "Toggle to create master_swap_usage_high alarm."
  type        = bool
  default     = true
}

variable "create_master_transaction_logs_disk_usage_high_alarm" {
  description = "Toggle to create master_transaction_logs_disk_usage_high alarm."
  type        = bool
  default     = true
}

variable "create_master_transaction_logs_generation_anomaly_alarm" {
  description = "Toggle to create master_transaction_logs_generation_anomaly alarm."
  type        = bool
  default     = true
}

variable "create_master_transaction_logs_generation_high_alarm" {
  description = "Toggle to create master_transaction_logs_generation_high alarm."
  type        = bool
  default     = true
}

variable "create_master_write_iops_anomaly_alarm" {
  description = "Toggle to create master_write_iops_anomaly alarm."
  type        = bool
  default     = true
}

variable "create_master_write_iops_high_alarm" {
  description = "Toggle to create master_write_iops_high alarm."
  type        = bool
  default     = true
}

variable "create_master_write_latency_anomaly_alarm" {
  description = "Toggle to create master_write_latency_anomaly alarm."
  type        = bool
  default     = true
}

variable "create_master_write_latency_high_alarm" {
  description = "Toggle to create master_write_latency_high alarm."
  type        = bool
  default     = true
}

variable "create_master_write_throughput_anomaly_alarm" {
  description = "Toggle to create master_write_throughput_anomaly alarm."
  type        = bool
  default     = true
}

variable "create_replica_checkpoint_lag_anomaly_alarm" {
  description = "Toggle to create replica_checkpoint_lag_anomaly alarm."
  type        = bool
  default     = true
}

variable "create_replica_checkpoint_lag_high_alarm" {
  description = "Toggle to create replica_checkpoint_lag_high alarm."
  type        = bool
  default     = true
}

variable "create_replica_cpu_utilization_high_alarm" {
  description = "Toggle to create replica_cpu_utilization_high alarm."
  type        = bool
  default     = true
}

variable "create_replica_cpu_utilization_anomaly_alarm" {
  description = "Toggle to create replica_cpu_utilization_anomaly alarm."
  type        = bool
  default     = true
}

variable "create_replica_db_connections_anomaly_alarm" {
  description = "Toggle to create replica_db_connections_anomaly alarm."
  type        = bool
  default     = true
}

variable "create_replica_db_connections_high_alarm" {
  description = "Toggle to create replica_db_connections_high alarm."
  type        = bool
  default     = true
}

variable "create_replica_db_load_anomaly_alarm" {
  description = "Toggle to create replica_db_load_anomaly alarm."
  type        = bool
  default     = true
}

variable "create_replica_db_load_cpu_anomaly_alarm" {
  description = "Toggle to create replica_db_load_cpu_anomaly alarm."
  type        = bool
  default     = true
}

variable "create_replica_db_load_high_alarm" {
  description = "Toggle to create replica_db_load_high alarm."
  type        = bool
  default     = true
}

variable "create_replica_db_load_non_cpu_anomaly_alarm" {
  description = "Toggle to create eplica_db_load_non_cpu_anomaly alarm."
  type        = bool
  default     = true
}

variable "create_replica_db_non_load_cpu_anomaly_alarm" {
  description = "Toggle to create replica_db_non_load_cpu_anomaly alarm."
  type        = bool
  default     = true
}

variable "create_replica_disk_queue_depth_anomaly_alarm" {
  description = "Toggle to create replica_disk_queue_depth_anomaly alarm."
  type        = bool
  default     = true
}

variable "create_replica_disk_queue_depth_high_alarm" {
  description = "Toggle to create replica_disk_queue_depth_high alarm."
  type        = bool
  default     = true
}

variable "create_replica_free_storage_space_anomaly_alarm" {
  description = "Toggle to create replica_free_storage_space_anomaly alarm."
  type        = bool
  default     = true
}

variable "create_replica_free_storage_space_low_alarm" {
  description = "Toggle to create replica_free_storage_space_low alarm."
  type        = bool
  default     = true
}

variable "create_replica_freeable_memory_anomaly_alarm" {
  description = "Toggle to create replica_freeable_memory_anomaly alarm."
  type        = bool
  default     = true
}

variable "create_replica_freeable_memory_low_alarm" {
  description = "Toggle to create replica_freeable_memory_low alarm."
  type        = bool
  default     = true
}

variable "create_replica_lag_high_alarm" {
  description = "Toggle to create replica_lag_high alarm."
  type        = bool
  default     = true
}

variable "create_replica_local_storage_pct_low_alarm" {
  description = "Toggle to create replica_local_storage_pct_low alarm."
  type        = bool
  default     = true
}

variable "create_replica_maximum_used_transaction_ids_anomaly_alarm" {
  description = "Toggle to create replica_maximum_used_transaction_ids_anomaly alarm."
  type        = bool
  default     = true
}

variable "create_replica_maximum_used_transaction_ids_high_alarm" {
  description = "Toggle to create replica_maximum_used_transaction_ids_high alarm."
  type        = bool
  default     = true
}

variable "create_replica_network_receive_throughput_anomaly_alarm" {
  description = "Toggle to create replica_network_receive_throughput_anomaly alarm."
  type        = bool
  default     = true
}

variable "create_replica_network_transmit_throughput_anomaly_alarm" {
  description = "Toggle to create replica_network_transmit_throughput_anomaly alarm."
  type        = bool
  default     = true
}

variable "create_replica_oldest_replication_slot_lag_anomaly_alarm" {
  description = "Toggle to create replica_oldest_replication_slot_lag_anomaly alarm."
  type        = bool
  default     = true
}

variable "create_replica_read_iops_anomaly_alarm" {
  description = "Toggle to create replica_read_iops_anomaly alarm."
  type        = bool
  default     = true
}

variable "create_replica_read_iops_high_alarm" {
  description = "Toggle to create replica_read_iops_high alarm."
  type        = bool
  default     = true
}

variable "create_replica_read_latency_anomaly_alarm" {
  description = "Toggle to create replica_read_latency_anomaly alarm."
  type        = bool
  default     = true
}

variable "create_replica_read_latency_high_alarm" {
  description = "Toggle to create replica_read_latency_high alarm."
  type        = bool
  default     = true
}

variable "create_replica_read_throughput_anomaly_alarm" {
  description = "Toggle to create replica_read_throughput_anomaly alarm."
  type        = bool
  default     = true
}

variable "create_replica_read_throughput_high_alarm" {
  description = "Toggle to create replica_read_throughput_high alarm."
  type        = bool
  default     = true
}

variable "create_replica_swap_usage_anomaly_alarm" {
  description = "Toggle to create replica_swap_usage_anomaly alarm."
  type        = bool
  default     = true
}

variable "create_replica_swap_usage_high_alarm" {
  description = "Toggle to create replica_swap_usage_high alarm."
  type        = bool
  default     = true
}

variable "create_replica_transaction_logs_disk_usage_anomaly_alarm" {
  description = "Toggle to create replica_transaction_logs_disk_usage_anomaly alarm."
  type        = bool
  default     = true
}

variable "create_replica_transaction_logs_disk_usage_high_alarm" {
  description = "Toggle to create replica_transaction_logs_disk_usage_high alarm."
  type        = bool
  default     = true
}

variable "create_replica_transaction_logs_generation_anomaly_alarm" {
  description = "Toggle to create replica_transaction_logs_generation_anomaly alarm."
  type        = bool
  default     = true
}

variable "create_replica_transaction_logs_generation_high_alarm" {
  description = "Toggle to create replica_transaction_logs_generation_high alarm."
  type        = bool
  default     = true
}

variable "create_replica_write_iops_anomaly_alarm" {
  description = "Toggle to create replica_write_iops_anomaly alarm."
  type        = bool
  default     = true
}

variable "create_replica_write_iops_high_alarm" {
  description = "Toggle to create replica_write_iops_high alarm."
  type        = bool
  default     = true
}

variable "create_replica_write_latency_anomaly_alarm" {
  description = "Toggle to create replica_write_latency_anomaly alarm."
  type        = bool
  default     = true
}

variable "create_replica_write_latency_high_alarm" {
  description = "Toggle to create replica_write_latency_high alarm."
  type        = bool
  default     = true
}

variable "create_replica_write_throughput_anomaly_alarm" {
  description = "Toggle to create replica_write_throughput_anomaly alarm."
  type        = bool
  default     = true
}

variable "db_connections_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "db_connections_threshold" {
  description = "The total number of connections to the db."
  type        = number
  default     = 1000
}

variable "db_instance_id" {
  description = "The instance ID of the RDS database instance that you want to monitor."
  type        = string
}

variable "db_load_cpu_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "db_load_cpu_threshold" {
  description = "The load the cpu must exceed to breach alarm."
  type        = number
  default     = 90
}

variable "db_load_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "db_load_non_cpu_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "db_load_non_cpu_threshold" {
  description = "The value non cpu load must exceed to breach alarm."
  type        = number
  default     = 90
}

variable "db_load_threshold" {
  description = "The load the db must exceed to breach alarm."
  type        = number
  default     = 90
}

variable "disk_queue_depth_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "disk_queue_depth_threshold" {
  description = "The maximum number of outstanding IOs (read/write requests) waiting to access the disk."
  type        = number
  default     = 100
}

variable "free_storage_space_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "free_storage_space_threshold" {
  description = "The minimum amount of available storage space in Byte."
  type        = number
  default     = 2000000000 #2GB in bytes
}

variable "freeable_memory_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "freeable_memory_threshold" {
  description = "The minimum amount of available random access memory in Byte."
  type        = number
  default     = 1073741824 #1GB in bytes
}

variable "local_storage_pct_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "local_storage_pct_threshold" {
  description = "The percentage of storage utilized that will trigger an alarm."
  type        = number
  default     = 85
}

variable "maximum_used_transaction_ids_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "maximum_used_transaction_ids_threshold" {
  description = "The number of unvacuumed transactions. Check autovacuum activity immediately."
  type        = number
  default     = 500000000000
}

variable "network_receive_throughput_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "network_transmit_throughput_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "oldest_replication_slot_lag_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "read_iops_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "read_iops_threshold" {
  description = "Number of read IOPS."
  type        = number
  default     = 20000
}

variable "read_latency_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "read_latency_threshold" {
  description = "The read latency threshold, in seconds."
  type        = number
  default     = 30
}

variable "read_throughput_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "replica_db_instance_id" {
  description = "The instance id of the read replica to monitor."
  type        = string
  default     = ""
}

variable "replica_lag_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "replica_lag_threshold" {
  description = "The replica lag threshold on the read replica."
  type        = number
  default     = 300
}

variable "sns_topic_name" {
  description = "The name of the SNS topic to publish alerts to."
  type        = string
}

variable "swap_usage_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "swap_usage_threshold" {
  description = "The maximum amount of swap space used on the DB instance in Byte."
  type        = number
  default     = 100000000000
}

variable "tags" {
  description = "Tags to be added to all resources."
  type        = map(string)
  default     = {}
}

variable "transaction_logs_disk_usage_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "transaction_logs_disk_usage_threshold" {
  description = "The size of locally stored transaction logs on disk."
  type        = number
  default     = 100000000000
}

variable "transaction_logs_generation_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "transaction_logs_generation_threshold" {
  description = "The amount of redo in MB that has been generated."
  type        = number
  default     = 500000000
}

variable "write_iops_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "write_iops_threshold" {
  description = "Number of write IOPS."
  type        = number
  default     = 20000
}

variable "write_latency_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "write_latency_threshold" {
  description = "The write latency threshold, in seconds."
  type        = number
  default     = 30
}

variable "write_throughput_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "write_throughput_threshold" {
  description = "The threshold value that must be exceeded to alarm."
  type        = number
  default     = 1000
}
