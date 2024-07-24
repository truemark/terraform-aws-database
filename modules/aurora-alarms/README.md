**terraform-aws-aurora-alarms**
This repo creates alarms specific to an Aurora RDS cluster. 

## Example Usage
```
module "cluster_alarms" {
  source                    = "truemark/aurora-alarms/aws"
  version                   = "0.0.2"
  db_cluster_id             = module.essentialist.cluster_id
  db_cluster_members        = module.essentialist.cluster_members
  sns_topic_name            = "SNSAlerts"
  tags                      = local.tags
  cpu_utilization_threshold = 95
  swap_usage_threshold      = 2147483648
  disk_queue_depth_evaluation_periods = 10
}
```
## Parameters
The following parameters are supported:

- cpu_utilization_threshold
- db_cluster_id
- db_cluster_members
- disk_queue_depth_evaluation_periods
- sns_topic_name
- swap_usage_threshold
- tags
