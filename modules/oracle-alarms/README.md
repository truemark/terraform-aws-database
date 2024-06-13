# terraform-aws-rds-oracle-alarms
Alarms specific to Oracle on RDS. 

The following alarms are created by default for the instance in the variable db_instance_id. They are loosely based upon the [documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/rds-metrics.html#rds-cw-metrics-instance).

- cpu_utilization_high
- disk_queue_depth_high
- free_storage_space_low
- freeable_memory_low
- percent_free_memory_low
- swap_usage_high

Each alarm has the following variables, set with sensible defaults. All thresholds and evaluation period default settings can be overridden.
1. create_[alarm-name], which controls whether or not the alarm is created. Default is true. This variable offers the ability to not create a specific alarm. 
2. [alarm-name]-threshold. The number which must be exceeded to generate an alert.
3. [alarm-name]-evaluation-periods. The number of evaluation periods that must be exceeded to generate an alert.