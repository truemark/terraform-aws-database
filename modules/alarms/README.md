<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.49.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_prometheus_rule_group_namespace.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/prometheus_rule_group_namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alert_critical_blocking_sessions_count"></a> [alert\_critical\_blocking\_sessions\_count](#input\_alert\_critical\_blocking\_sessions\_count) | Number of blocking sessions before trigger a critical alert | `number` | `5` | no |
| <a name="input_alert_critical_recovery_file_destination_used_percent"></a> [alert\_critical\_recovery\_file\_destination\_used\_percent](#input\_alert\_critical\_recovery\_file\_destination\_used\_percent) | Percentage of recovery file destination used before trigger a critical alert | `number` | `95` | no |
| <a name="input_alert_critical_session_utilization_percent"></a> [alert\_critical\_session\_utilization\_percent](#input\_alert\_critical\_session\_utilization\_percent) | Percentage of session utilization before trigger a critical alert | `number` | `95` | no |
| <a name="input_alert_critical_tablespace_used_percent"></a> [alert\_critical\_tablespace\_used\_percent](#input\_alert\_critical\_tablespace\_used\_percent) | Percentage of used tablespace before trigger a critical alert | `map(number)` | `null` | no |
| <a name="input_alert_critical_tablespace_used_percent_global"></a> [alert\_critical\_tablespace\_used\_percent\_global](#input\_alert\_critical\_tablespace\_used\_percent\_global) | Percentage of used tablespace before trigger a critical alert | `number` | `95` | no |
| <a name="input_alert_database_down"></a> [alert\_database\_down](#input\_alert\_database\_down) | Enable alert for database down | `bool` | `true` | no |
| <a name="input_alert_warning_blocking_sessions_count"></a> [alert\_warning\_blocking\_sessions\_count](#input\_alert\_warning\_blocking\_sessions\_count) | Number of blocking sessions before triggering a warning alert | `number` | `2` | no |
| <a name="input_alert_warning_recovery_file_destination_used_percent"></a> [alert\_warning\_recovery\_file\_destination\_used\_percent](#input\_alert\_warning\_recovery\_file\_destination\_used\_percent) | Percentage of recovery file destination used before trigger a warning alert | `number` | `90` | no |
| <a name="input_alert_warning_session_utilization_percent"></a> [alert\_warning\_session\_utilization\_percent](#input\_alert\_warning\_session\_utilization\_percent) | Percentage of session utilization before trigger a warning alert | `number` | `90` | no |
| <a name="input_alert_warning_tablespace_used_percent"></a> [alert\_warning\_tablespace\_used\_percent](#input\_alert\_warning\_tablespace\_used\_percent) | Percentage of used tablespace before trigger a warning alert | `map(number)` | `null` | no |
| <a name="input_alert_warning_tablespace_used_percent_global"></a> [alert\_warning\_tablespace\_used\_percent\_global](#input\_alert\_warning\_tablespace\_used\_percent\_global) | Percentage of used tablespace before trigger a warning alert | `number` | `90` | no |
| <a name="input_database_identifier"></a> [database\_identifier](#input\_database\_identifier) | Identifier of the databsae to create alarms for | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace to in which to create alarms, default is based on database\_identifier | `string` | n/a | yes |
| <a name="input_prometheus_workspace_id"></a> [prometheus\_workspace\_id](#input\_prometheus\_workspace\_id) | ID of the workspace to create the alarms in | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->