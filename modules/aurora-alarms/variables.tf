variable "db_cluster_id" {
  description = "The cluster ID of the RDS Aurora cluster that you want to monitor."
  type        = string
}

variable "db_cluster_members" {
  description = "List of RDS Instances that are a part of the cluster"
  type        = set(string)
}

variable "tags" {
  description = "Tags to be added to all resources."
  type        = map(string)
}

variable "cpu_utilization_threshold" {
  description = "The maximum percentage of CPU utilization."
  type        = number
  default     = 90
}

variable "cpu_utilization_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 5
}

variable "enable_percent_free_memory_low_alarm" {
  description = "Toggle to create percent_free_memory_low alarm."
  type        = bool
  default     = true
}

variable "enable_cpu_utilization_high_alarm" {
  description = "Toggle to create cpu_utilization_high alarm."
  type        = bool
  default     = true
}

variable "enable_disk_queue_depth_high_alarm" {
  description = "Toggle to create disk_queue_depth_high alarm."
  type        = bool
  default     = true
}

variable "enable_freeable_memory_low_alarm" {
  description = "Toggle to create freeable_memory_low alarm."
  type        = bool
  default     = true
}

variable "enable_free_storage_space_low_alarm" {
  description = "Toggle to create free_storage_space_low alarm."
  type        = bool
  default     = true
}

variable "enable_swap_usage_high_alarm" {
  description = "Toggle to create swap_usage_high alarm."
  type        = bool
  default     = true
}

variable "disk_queue_data_points_to_alarm" {
  description = "The number of datapoints that must be breaching to trigger the alarm."
  type        = number
  default     = 10
}

variable "cpu_utilization_data_points_to_alarm" {
  description = "The number of datapoints that must be breaching to trigger the alarm. Leave null to let CloudWatch use evaluation_periods."
  type        = number
  default     = null
}

variable "freeable_memory_data_points_to_alarm" {
  description = "The number of datapoints that must be breaching to trigger the alarm. Leave null to let CloudWatch use evaluation_periods."
  type        = number
  default     = null
}

variable "free_storage_space_data_points_to_alarm" {
  description = "The number of datapoints that must be breaching to trigger the alarm. Leave null to let CloudWatch use evaluation_periods."
  type        = number
  default     = null
}

variable "swap_usage_data_points_to_alarm" {
  description = "The number of datapoints that must be breaching to trigger the alarm. Leave null to let CloudWatch use evaluation_periods."
  type        = number
  default     = null
}

variable "disk_queue_depth_threshold" {
  description = "The maximum number of outstanding IOs (read/write requests) waiting to access the disk."
  type        = number
  default     = 1000
}

variable "disk_queue_depth_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "freeable_memory_threshold" {
  description = "The minimum amount of available random access memory in Byte."
  type        = number
  default     = 1073741824 #1GB in bytes
}

variable "freeable_memory_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 5
}

variable "free_storage_space_threshold" {
  description = "The minimum amount of available storage space in bytes."
  type        = number
  default     = 2000000000

  # 2 Gigabyte in Byte
}

variable "swap_usage_threshold" {
  description = "The maximum amount of swap space used on the DB instance in bytes."
  type        = number
  default     = 1073741824

  # 256 Megabyte in Byte
}

variable "swap_usage_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 5
}

variable "percent_free_memory_threshold" {
  description = "The percent of memory that is unused."
  type        = number
  default     = 10
}

variable "percent_free_memory_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 5
}

variable "enable_database_connections_high_alarm" {
  description = "Toggle to create database_connections_high alarm."
  type        = bool
  default     = true
}

variable "database_connections_threshold" {
  description = "The number of connections that triggers the alarm. The alarm is not created unless this is set."
  type        = number
  default     = 0
}

variable "database_connections_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 5
}

variable "database_connections_data_points_to_alarm" {
  description = "The number of datapoints that must be breaching to trigger the alarm."
  type        = number
  default     = 3
}

variable "sns_topic_name" {
  description = "The name of the SNS topic to publish alerts to."
  type        = string
}

variable "treat_missing_data" {
  description = "How the alarms handle missing data points. Valid values are breaching, notBreaching, ignore and missing."
  type        = string
  default     = "breaching"

  validation {
    condition     = contains(["breaching", "notBreaching", "ignore", "missing"], var.treat_missing_data)
    error_message = "treat_missing_data must be one of breaching, notBreaching, ignore or missing."
  }
}

variable "instance_event_categories" {
  description = "Event categories for the db-instance event subscription. An empty list subscribes to all categories."
  type        = list(string)
  default = [
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
}

variable "cluster_event_categories" {
  description = "Event categories for the db-cluster event subscription. An empty list subscribes to all categories."
  type        = list(string)
  default = [
    "configuration change",
    "deletion",
    "failure",
    "failover",
    "global-failover",
    "maintenance",
    "notification",
  ]
}
