output "password" {
  description = "The password used in the secret"
  value       = join("", random_password.secret.*.result)
  sensitive   = true
}

output "secret_id" {
  description = "The ID of the secret"
  value       = join("", aws_secretsmanager_secret.secret.*.id)
}

output "secret_arn" {
  description = "The ARN of the secret"
  value       = join("", aws_secretsmanager_secret.secret.*.arn)
}
