variable "namespace" {
  description = "Namespace to in which to create alarms, default is based on database_identifier"
  type        = string
}

variable "prometheus_workspace_id" {
  description = "ID of the workspace to create the alarms in"
  type        = string
}

variable "database_identifier" {
  description = "Identifier of the databsae to create alarms for"
  type        = string
}

variable "alert_database_down" {
  description = "Enable alert for database down"
  type        = bool
  default     = true
  nullable    = false
}

variable "alert_warning_blocking_sessions_count" {
  description = "Number of blocking sessions before triggering a warning alert"
  type        = number
  default     = 2
  nullable    = true
}

variable "alert_critical_blocking_sessions_count" {
  description = "Number of blocking sessions before trigger a critical alert"
  type        = number
  default     = 5
  nullable    = true
}

variable "alert_warning_tablespace_used_percent_global" {
  description = "Percentage of used tablespace before trigger a warning alert"
  type        = number
  default     = 90
  nullable    = true
}

variable "alert_critical_tablespace_used_percent_global" {
  description = "Percentage of used tablespace before trigger a critical alert"
  type        = number
  default     = 95
  nullable    = true
}

variable "alert_warning_tablespace_used_percent" {
  description = "Percentage of used tablespace before trigger a warning alert"
  type        = map(number)
  default     = null
  nullable    = true
  #   default = {
  #     "SYSTEM" = 90
  #     "SYSAUX" = 90
  #     "USERS"  = 90
  #   }
}

variable "alert_critical_tablespace_used_percent" {
  description = "Percentage of used tablespace before trigger a critical alert"
  type        = map(number)
  default     = null
  nullable    = true
}

variable "alert_warning_session_utilization_percent" {
  description = "Percentage of session utilization before trigger a warning alert"
  type        = number
  default     = 90
  nullable    = true
}

variable "alert_critical_session_utilization_percent" {
  description = "Percentage of session utilization before trigger a critical alert"
  type        = number
  default     = 95
  nullable    = true
}

variable "alert_warning_recovery_file_destination_used_percent" {
  description = "Percentage of recovery file destination used before trigger a warning alert"
  type        = number
  default     = 90
  nullable    = true
}

variable "alert_critical_recovery_file_destination_used_percent" {
  description = "Percentage of recovery file destination used before trigger a critical alert"
  type        = number
  default     = 95
  nullable    = true
}
