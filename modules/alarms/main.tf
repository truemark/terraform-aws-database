provider "aws" {
  region = "us-east-2"
}

resource "aws_prometheus_rule_group_namespace" "this" {
  name         = var.namespace
  workspace_id = var.prometheus_workspace_id
  data = templatefile("${path.module}/templates/database-collector.tftpl", {
    database_identifier                                   = var.database_identifier,
    alert_database_down                                   = var.alert_database_down,
    alert_warning_blocking_sessions_count                 = var.alert_warning_blocking_sessions_count,
    alert_critical_blocking_sessions_count                = var.alert_critical_blocking_sessions_count
    alert_warning_tablespace_used_percent_global          = var.alert_warning_tablespace_used_percent_global,
    alert_critical_tablespace_used_percent_global         = var.alert_critical_tablespace_used_percent_global,
    alert_warning_tablespace_used_percent                 = var.alert_warning_tablespace_used_percent,
    alert_critical_tablespace_used_percent                = var.alert_critical_tablespace_used_percent,
    alert_warning_session_utilization_percent             = var.alert_warning_session_utilization_percent,
    alert_critical_session_utilization_percent            = var.alert_critical_session_utilization_percent,
    alert_warning_recovery_file_destination_used_percent  = var.alert_warning_recovery_file_destination_used_percent,
    alert_critical_recovery_file_destination_used_percent = var.alert_critical_recovery_file_destination_used_percent,
  })
}

