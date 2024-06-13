output "cpu_utilization_high_threshold" {
  description = "The maximum percentage of CPU utilization allowed before triggering alarm."
  value       = aws_cloudwatch_metric_alarm.cpu_utilization_high.threshold
}

output "db_connections_threshold" {
  description = "The maximum percentage of CPU utilization allowed before triggering alarm."
  value       = resource.aws_cloudwatch_metric_alarm.db_connections_high.threshold
}

output "page_life_expectancy_threshold" {
  description = "The maximum percentage of CPU utilization allowed before triggering alarm."
  value       = resource.aws_cloudwatch_metric_alarm.page_life_expectancy_static[*].threshold
}
