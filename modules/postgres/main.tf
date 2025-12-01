locals {
  port = 5432

  tags = merge(var.tags,
    {
      "automation:component-id"     = "terraform-aws-rds-postgres",
      "automation:component-url"    = "https://registry.terraform.io/modules/truemark/database/aws/latest/submodules/postgres",
      "automation:component-vendor" = "TrueMark",
      "backup:policy"               = var.backup_policy,
  })
}
data "aws_kms_alias" "db" {
  count = var.create_db_instance && var.kms_key_arn == null && var.kms_key_id == null && var.kms_key_alias != null ? 1 : 0
  name  = var.kms_key_alias
}
data "aws_kms_key" "db" {
  count  = var.create_db_instance && var.kms_key_arn == null && var.kms_key_id != null ? 1 : 0
  key_id = var.kms_key_id
}
resource "random_password" "db" {
  count   = var.create_db_instance ? 1 : 0
  length  = var.random_password_length
  special = false
}
resource "aws_security_group" "db" {
  count  = var.create_db_instance ? 1 : 0
  name   = var.instance_name
  vpc_id = var.vpc_id
  tags   = local.tags

  ingress {
    from_port   = local.port
    to_port     = local.port
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidrs
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = var.egress_cidrs
  }
}
data "aws_iam_policy_document" "rds_enhanced_monitoring" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "rds_enhanced_monitoring" {
  count              = var.create_db_instance ? 1 : 0
  name               = "rds-enhanced-monitoring-${lower(var.instance_name)}"
  assume_role_policy = data.aws_iam_policy_document.rds_enhanced_monitoring.json
  tags               = local.tags
}

resource "aws_iam_role_policy_attachment" "rds_enhanced_monitoring" {
  count      = var.create_db_instance ? 1 : 0
  role       = aws_iam_role.rds_enhanced_monitoring[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}
module "db" {
  # https://registry.terraform.io/modules/terraform-aws-modules/rds/aws/latest
  source  = "terraform-aws-modules/rds/aws"
  version = "6.7.0"

  allocated_storage                     = var.allocated_storage
  apply_immediately                     = var.apply_immediately
  auto_minor_version_upgrade            = var.auto_minor_version_upgrade
  backup_retention_period               = var.backup_retention_period
  ca_cert_identifier                    = var.ca_cert_identifier
  copy_tags_to_snapshot                 = var.copy_tags_to_snapshot
  create_db_instance                    = var.create_db_instance
  create_db_parameter_group             = true
  create_db_subnet_group                = true
  db_instance_tags                      = local.tags
  db_name                               = var.database_name
  db_subnet_group_tags                  = local.tags
  deletion_protection                   = var.deletion_protection
  engine                                = "postgres"
  engine_version                        = var.engine_version
  family                                = var.family
  identifier                            = var.replica_count == 0 ? var.instance_name : "${var.instance_name}${var.master_name_variable}"
  instance_class                        = var.instance_type
  iops                                  = var.iops
  kms_key_id                            = var.kms_key_arn != null ? var.kms_key_arn : (var.kms_key_id != null) ? join("", data.aws_kms_key.db.*.arn) : (var.kms_key_alias != null) ? join("", data.aws_kms_alias.db.*.target_key_arn) : null
  major_engine_version                  = var.major_engine_version
  manage_master_user_password           = var.manage_master_user_password
  max_allocated_storage                 = var.max_allocated_storage
  monitoring_interval                   = var.monitoring_interval
  monitoring_role_arn                   = join("", aws_iam_role.rds_enhanced_monitoring.*.arn)
  multi_az                              = var.multi_az
  parameters                            = var.db_parameters
  password                              = var.manage_master_user_password ? null : (var.password != null ? var.password : join("", random_password.db.*.result))
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = 7
  replicate_source_db                   = var.replicate_source_db
  skip_final_snapshot                   = var.skip_final_snapshot
  snapshot_identifier                   = var.snapshot_identifier
  storage_encrypted                     = true
  storage_type                          = var.storage_type
  subnet_ids                            = var.subnet_ids
  tags                                  = local.tags
  username                              = var.username
  vpc_security_group_ids                = [join("", aws_security_group.db.*.id)]
}
module "master_secret" {
  source  = "truemark/rds-secret/aws"
  version = "1.2.3"

  count         = var.create_db_instance && var.manage_master_user_password ? 0 : 1
  create        = var.create_db_instance && var.create_secrets
  cluster       = false
  database_name = var.database_name != null ? var.database_name : "postgres"
  identifier    = module.db.db_instance_identifier
  name          = "master"
  username      = module.db.db_instance_username
  password      = var.password != null ? var.password : join("", random_password.db.*.result)
  tags          = local.tags
  depends_on    = [module.db]
}

resource "aws_db_instance" "replica" {
  count = var.create_db_instance ? var.replica_count : 0

  identifier     = "${var.instance_name}-replica-${count.index + 1}"
  instance_class = var.replica_instance_class != null ? var.replica_instance_class : var.instance_type

  replicate_source_db = module.db.db_instance_identifier

  # Replica-specific settings
  auto_minor_version_upgrade            = var.auto_minor_version_upgrade
  apply_immediately                     = var.apply_immediately
  ca_cert_identifier                    = var.ca_cert_identifier
  copy_tags_to_snapshot                 = var.copy_tags_to_snapshot
  deletion_protection                   = var.deletion_protection
  enabled_cloudwatch_logs_exports       = ["postgresql"]
  iam_database_authentication_enabled   = false
  iops                                  = var.iops
  kms_key_id                            = var.kms_key_arn != null ? var.kms_key_arn : (var.kms_key_id != null) ? join("", data.aws_kms_key.db.*.arn) : (var.kms_key_alias != null) ? join("", data.aws_kms_alias.db.*.target_key_arn) : null
  monitoring_interval                   = var.monitoring_interval
  monitoring_role_arn                   = join("", aws_iam_role.rds_enhanced_monitoring.*.arn)
  multi_az                              = var.multi_az
  parameter_group_name                  = module.db.db_parameter_group_id
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period
  performance_insights_kms_key_id       = var.performance_insights_kms_key_id
  publicly_accessible                   = var.publicly_accessible
  skip_final_snapshot                   = var.skip_final_snapshot
  storage_encrypted                     = true
  storage_throughput                    = var.storage_throughput
  storage_type                          = var.storage_type
  vpc_security_group_ids                = [join("", aws_security_group.db.*.id)]

  tags = merge(local.tags, var.db_instance_tags, {
    "Name" = "${var.instance_name}-replica-${count.index + 1}"
  })

  depends_on = [module.db]
}

