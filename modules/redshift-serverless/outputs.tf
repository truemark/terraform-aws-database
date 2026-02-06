output "namespace_name" {
  value = aws_redshiftserverless_namespace.namespace.namespace_name
}

output "workgroup_name" {
  value = aws_redshiftserverless_workgroup.workgroup.workgroup_name
}

output "endpoint" {
  value = aws_redshiftserverless_workgroup.workgroup.endpoint
}

output "admin_secret_arn" {
  value = aws_secretsmanager_secret.redshift_secret.arn
}
