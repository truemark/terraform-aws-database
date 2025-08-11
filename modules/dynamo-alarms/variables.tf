variable "dynamodb_table_names" {
  description = "List of DynamoDB table names to monitor"
  type        = set(string)
}

variable "sns_topic_name" {
  description = "The name of the SNS topic to publish alerts to"
  type        = string
}

variable "tags" {
  description = "Tags to be added to all resources"
  type        = map(string)
  default     = {}
}

variable "alarm_prefix" {
  description = "Prefix for alarm names"
  type        = string
  default     = "dynamodb-monitoring"
}

variable "dynamodb_enable_alarms" {
  description = "Enable DynamoDB CloudWatch alarms"
  type        = bool
  default     = true
}

variable "dynamodb_throttled_requests_threshold" {
  description = "Threshold for throttled requests per minute"
  type        = number
  default     = 10
}

variable "dynamodb_system_errors_threshold" {
  description = "Threshold for system errors per minute"
  type        = number
  default     = 5
}

variable "dynamodb_conditional_check_failures_threshold" {
  description = "Threshold for conditional check failures per minute"
  type        = number
  default     = 20
}

variable "dynamodb_latency_threshold" {
  description = "Threshold for successful request latency (milliseconds)"
  type        = number
  default     = 1000
}

