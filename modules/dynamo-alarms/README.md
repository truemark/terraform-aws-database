# terraform-aws-dynamodb-alarms

This Terraform module creates CloudWatch alarms for monitoring DynamoDB tables and AWS service events.

## Features

- Monitors key DynamoDB metrics:
  - Throttled requests
  - System errors
  - Conditional check failures
  - Request latency (read/write)
- Integrates with AWS Health Dashboard to detect service events
- Routes all alerts to a central SNS topic

## Example Usage

```hcl
module "dynamodb_alarms" {
  source = "path/to/terraform-aws-dynamodb-alarms"

  dynamodb_table_names   = ["users-table", "orders-table"]
  sns_topic_name         = "SNSAlerts"
  tags                   = {
    Environment = "production"
    Team        = "backend"
  }
  
  # Optional thresholds (defaults shown)
  dynamodb_throttled_requests_threshold        = 10
  dynamodb_system_errors_threshold             = 5
  dynamodb_conditional_check_failures_threshold = 20
  dynamodb_latency_threshold                   = 1000  # milliseconds
}

