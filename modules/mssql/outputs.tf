output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = join("", module.db.*.db_instance_address)
}

output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = join("", module.db.*.db_instance_arn)
}

output "db_instance_availability_zone" {
  description = "The availability zone of the RDS instance"
  value       = join("", module.db.*.db_instance_availability_zone)
}

output "db_instance_ca_cert_identifier" {
  description = "Specifies the identifier of the CA certificate for the DB instance"
  value       = join("", module.db.*.db_instance_ca_cert_identifier)
}

output "db_instance_domain" {
  description = "The ID of the Directory Service Active Directory domain the instance is joined to"
  value       = [module.db.*.db_instance_domain]
  # value = join("", module.db[0].db_instance_domain)
}

output "db_instance_domain_iam_role_name" {
  description = "The name of the IAM role to be used when making API calls to the Directory Service. "
  value       = module.db.*.db_instance_domain_iam_role_name
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = join("", module.db.*.db_instance_endpoint)
}

output "db_instance_hosted_zone_id" {
  description = "The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record)"
  value       = join("", module.db.*.db_instance_hosted_zone_id)
}

output "db_instance_name" {
  description = "The database name"
  value       = join("", module.db.*.db_instance_name)
}

output "db_instance_port" {
  description = "The database port"
  value       = join("", module.db.*.db_instance_port)
}

output "db_instance_resource_id" {
  description = "The RDS Resource ID of this instance"
  value       = join("", module.db.*.db_instance_resource_id)
}

output "db_instance_status" {
  description = "The RDS instance status"
  value       = join("", module.db.*.db_instance_status)
}

output "db_instance_username" {
  description = "The master username for the database"
  value       = join("", module.db.*.db_instance_username)
  sensitive   = true
}

output "db_parameter_group_arn" {
  description = "The ARN of the db parameter group"
  value       = aws_db_parameter_group.db_parameter_group.*.id
}

output "db_parameter_group_id" {
  description = "The db parameter group id"
  value       = aws_db_parameter_group.db_parameter_group.*.id
}

output "enhanced_monitoring_iam_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the monitoring role"
  value       = join("", module.db.*.enhanced_monitoring_iam_role_arn)
}

output "enhanced_monitoring_iam_role_name" {
  description = "The name of the monitoring role"
  value       = join("", module.db.*.enhanced_monitoring_iam_role_name)
}

output "master_secret_arn" {
  description = "The id of the secret storing root credentials."
  value       = aws_secretsmanager_secret.db.*.arn
}

output "master_secret_id" {
  description = "The id of the secret storing root credentials."
  value       = aws_secretsmanager_secret.db.*.id
}

output "db_security_group_id" {
  description = "The id of the database security group"
  value       = aws_security_group.db_security_group.*.id
}
