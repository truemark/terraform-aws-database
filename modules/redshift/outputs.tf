output "cluster_identifier" {
  value       = aws_redshift_cluster.redshift.cluster_identifier
  description = "Redshift cluster identifier"
}

output "endpoint" {
  value       = aws_redshift_cluster.redshift.endpoint
  description = "Redshift cluster endpoint"
}

output "port" {
  value       = aws_redshift_cluster.redshift.port
  description = "Port Redshift listens on"
}

output "node_type" {
  value       = aws_redshift_cluster.redshift.node_type
  description = "Redshift node type"
}

output "cluster_type" {
  value       = aws_redshift_cluster.redshift.cluster_type
  description = "Redshift cluster type"
}

output "database_name" {
  value       = aws_redshift_cluster.redshift.database_name
  description = "Default database name"
}

output "redshift_password_secret_arn" {
  value       = aws_secretsmanager_secret.redshift_password.arn
  description = "ARN of the Secrets Manager secret holding master password"
}

output "redshift_sg_id" {
  value       = aws_security_group.redshift_sg.id
  description = "Security group ID for Redshift"
}