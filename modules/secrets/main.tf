module "standard_tags" {
  source  = "truemark/standard-tags/aws"
  version = "1.0.0"
  automation_component = {
    id     = "terraform-aws-rds-secret"
    url    = "https://registry.terraform.io/modules/truemark/standard-tags"
    vendor = "TrueMark"
  }
}

data "aws_rds_cluster" "cluster" {
  count              = var.cluster ? 1 : 0
  cluster_identifier = var.identifier
}

data "aws_db_instances" "instances" {
  filter {
    name   = "db-instance-id"
    values = [var.identifier]
  }
}

data "aws_db_instance" "instance" {
  count                  = var.cluster ? 0 : 1
  db_instance_identifier = data.aws_db_instances.instances.instance_identifiers[0]
}

resource "random_password" "secret" {
  count       = var.create ? 1 : 0
  length      = var.password_length
  special     = var.special
  min_upper   = var.min_upper
  min_lower   = var.min_lower
  min_numeric = var.min_numeric
}

resource "aws_secretsmanager_secret" "secret" {
  count       = var.create ? 1 : 0
  name_prefix = "database/${var.identifier}/${var.name != null ? var.name : var.username}-"
  description = "Application password for RDS ${var.cluster ? "Cluster" : "Instance"} ${var.identifier}"
  tags        = merge(var.tags, module.standard_tags.tags)
}

resource "aws_secretsmanager_secret_version" "cluster_secret" {
  count     = var.create && var.cluster ? 1 : 0
  secret_id = aws_secretsmanager_secret.secret[count.index].id
  secret_string = jsonencode({
    host     = data.aws_rds_cluster.cluster[count.index].endpoint
    port     = data.aws_rds_cluster.cluster[count.index].port
    dbname   = var.database_name == null ? data.aws_rds_cluster.cluster[count.index].database_name : var.database_name
    username = var.username == null ? var.name : var.username
    password = var.password != null ? var.password : join("", random_password.secret.*.result)
    engine   = data.aws_rds_cluster.cluster[count.index].engine
  })
  lifecycle {
    ignore_changes = [secret_string]
  }
}

resource "aws_secretsmanager_secret_version" "instance_secret" {
  count     = var.create && !var.cluster ? 1 : 0
  secret_id = aws_secretsmanager_secret.secret[count.index].id
  secret_string = jsonencode({
    host     = data.aws_db_instance.instance[count.index].address
    port     = data.aws_db_instance.instance[count.index].port
    dbname   = var.database_name == null ? data.aws_db_instance.instance[count.index].db_name : var.database_name
    username = var.username == null ? var.name : var.username
    password = var.password != null ? var.password : join("", random_password.secret.*.result)
    engine   = data.aws_db_instance.instance[count.index].engine
  })
  lifecycle {
    ignore_changes = [secret_string]
  }
}

