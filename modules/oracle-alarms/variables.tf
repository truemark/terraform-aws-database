variable "cpu_utilization_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 5
}

variable "cpu_utilization_threshold" {
  description = "The maximum percentage of CPU utilization."
  type        = number
  default     = 90
}

variable "create_cpu_utilization_alarm" {
  description = "Toggle to create cpu_utilization_high_alarm."
  type        = bool
  default     = true
}

variable "create_disk_queue_depth_alarm" {
  description = "Toggle to create disk_queue_depth_alarm."
  type        = bool
  default     = true
}

variable "create_free_storage_space_alarm" {
  description = "Toggle to create free_storage_space_alarm."
  type        = bool
  default     = true
}

variable "create_freeable_memory_alarm" {
  description = "Toggle to create freeable_memory_alarm."
  type        = bool
  default     = true
}

variable "create_percent_free_memory_alarm" {
  description = "Toggle to create percent_free_memory_alarm."
  type        = bool
  default     = true
}

variable "create_swap_usage_alarm" {
  description = "Toggle to create swap_usage_alarm."
  type        = bool
  default     = true
}

variable "db_instance_id" {
  description = "The instance ID of the RDS database instance that you want to monitor."
  type        = string
  default     = ""
}

variable "disk_queue_depth_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 5
}

variable "disk_queue_depth_threshold" {
  description = "The maximum number of outstanding IOs (read/write requests) waiting to access the disk."
  type        = number
  default     = 1000
}

variable "free_storage_space_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 5
}

variable "free_storage_space_threshold" {
  description = "The minimum amount of available storage space in Byte."
  type        = number
  default     = 2000000000 # 2 Gigabyte in Byte
}

variable "freeable_memory_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 5
}

variable "freeable_memory_threshold" {
  description = "The minimum amount of available random access memory in Byte."
  type        = number
  default     = 2147483648 #2GB in bytes
}

variable "percent_free_memory_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 5
}

variable "percent_free_memory_threshold" {
  description = "The percent of memory that is unused."
  type        = number
  default     = 10
}

variable "sns_topic_name" {
  description = "The name of the SNS topic to publish alerts to."
  type        = string
}

variable "swap_usage_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 5
}

variable "swap_usage_threshold" {
  description = "The maximum amount of swap space used on the DB instance in Byte."
  type        = number
  default     = 256000000 # 256 Megabyte in Byte
}

variable "tags" {
  description = "Tags to be added to all resources."
  type        = map(string)
}
