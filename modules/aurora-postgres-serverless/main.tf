resource "aws_db_parameter_group" "db" {
  count       = var.create_cluster && var.db_parameter_group_name == null ? 1 : 0
  name        = var.name
  family      = var.family
  description = "Parameter group for ${var.name}"
  dynamic "parameter" {
    for_each = var.db_parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }
  tags = merge(var.tags, var.db_parameter_group_tags)
}

resource "aws_rds_cluster_parameter_group" "db" {
  count       = var.create_cluster && var.rds_cluster_parameter_group_name == null ? 1 : 0
  name        = var.name
  family      = var.family
  description = "Cluster parameter group for ${var.name}"
  dynamic "parameter" {
    for_each = var.rds_cluster_parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }
  tags = merge(var.tags, var.rds_cluster_parameter_group_tags)
}

module "db" {
  # https://registry.terraform.io/modules/terraform-aws-modules/rds-aurora/aws/latest
  source         = "terraform-aws-modules/rds-aurora/aws"
  version        = "6.1.3"
  name           = var.name
  database_name  = var.database_name
  engine         = "aurora-postgresql"
  engine_version = var.engine_version
  engine_mode    = "serverless"

  scaling_configuration = {
    auto_pause               = var.auto_pause
    min_capacity             = var.min_capacity
    max_capacity             = var.max_capacity
    seconds_until_auto_pause = var.seconds_until_auto_pause
    timeout_action           = var.timeout_action
  }

  vpc_id                          = var.vpc_id
  subnets                         = var.subnets
  monitoring_interval             = 60
  apply_immediately               = var.apply_immediately
  skip_final_snapshot             = var.skip_final_snapshot
  storage_encrypted               = true
  db_parameter_group_name         = var.db_parameter_group_name == null ? element(aws_db_parameter_group.db.*.name, 1) : var.db_parameter_group_name
  db_cluster_parameter_group_name = var.rds_cluster_parameter_group_name == null ? element(aws_rds_cluster_parameter_group.db.*.name, 1) : var.rds_cluster_parameter_group_name
  allowed_cidr_blocks             = var.allowed_cidr_blocks
  backup_retention_period         = var.backup_retention_period
  preferred_backup_window         = var.preferred_backup_window
  preferred_maintenance_window    = var.preferred_maintenance_window
  deletion_protection             = var.deletion_protection
  tags                            = var.tags
  cluster_tags                    = var.cluster_tags
  copy_tags_to_snapshot           = var.copy_tags_to_snapshot
  security_group_tags             = var.security_group_tags
  create_random_password          = var.master_password == null
  master_password                 = var.master_password
  master_username                 = var.master_username
  create_security_group           = var.create_security_group
  snapshot_identifier             = var.snapshot_identifier
  kms_key_id                      = var.kms_key_id
  enable_http_endpoint            = var.enable_http_endpoint
}

resource "aws_ram_resource_share" "db" {
  count                     = var.create_cluster && var.share ? 1 : 0
  name                      = "${var.name}-rds"
  allow_external_principals = false
  tags                      = merge(var.tags, var.share_tags)
}

resource "aws_secretsmanager_secret" "db" {
  count       = var.create_cluster && var.store_master_password_as_secret ? 1 : 0
  name_prefix = var.master_password_secret_name_prefix == null ? "database/${var.name}/master-" : var.master_password_secret_name_prefix
  description = "Master password for ${var.name}"
  tags        = merge(var.tags, var.password_secret_tags)
}

resource "aws_secretsmanager_secret_version" "db" {
  count     = var.create_cluster && var.store_master_password_as_secret ? 1 : 0
  secret_id = aws_secretsmanager_secret.db[count.index].id
  secret_string = jsonencode({
    host     = module.db.cluster_endpoint
    port     = module.db.cluster_port
    dbname   = module.db.cluster_database_name
    username = module.db.cluster_master_username
    password = module.db.cluster_master_password
  })
}
