# terraform-aws-mssql-alarms
Alarms specific to MSSQL on RDS. 

The following alarms are created by default for the instance in the variable db_instance_id. They are loosely based upon the [documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/rds-metrics.html#rds-cw-metrics-instance). Anomaly alarms have a suffix of _anomaly, and can be disabled with the parameter anomaly_actions_enabled.

NOTE: Performance Insights must be enabled on the target db in order for all alarms to populate.

- cpu_utilization_high
- db_connections_high
- db_load_cpu_high
- db_load_high
- db_load_non_cpu_high
- deadlocks_per_second_anomaly
- deadlocks_per_second_static
- disk_queue_depth_high
- failed_sql_server_agent_jobs_count_high
- freeable_memory_low
- free_storage_space_low
- lock_waits_per_second_anomaly
- lock_waits_per_second_static
- network_receive_throughput
- network_transmit_throughput
- page_life_expectancy_static
- page_life_expectancy_anomaly
- read_iops
- read_latency
- read_throughput
- swap_usage
- recompilations_per_second_static
- recompilations_per_second_anomaly
- temp_db_available_data_space_low
- temp_db_available_log_space_low
- temp_db_data_file_usage_high
- temp_db_log_file_usage_high
- write_iops
- write_latency
- write_throughput

Each alarm has the following variables, set with sensible defaults. All thresholds and evaluation period default settings can be overridden.
1. create_[alarm-name], which controls whether or not the alarm is created. Default is true. This variable offers the ability to not create a specific alarm. 
2. [alarm-name]-threshold. The number which must be exceeded to generate an alert.
3. [alarm-name]-evaluation-periods. The number of evaluation periods that must be exceeded to generate an alert.
4. [alarm-name]_enabled. Whether or not to enable alarm actions. Default is true.

