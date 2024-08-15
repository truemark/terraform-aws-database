locals {
  domain_role_name = "${var.instance_name}-active-directory"
  }

locals {
  tags = merge(var.tags,
    {
      "automation:component-id"     = "rds-sqlserver",
      "automation:component-url"    = "https://registry.terraform.io/modules/truemark/database/aws/latest/submodules/mssql",
      "automation:component-vendor" = "TrueMark",
      "backup:policy"               = var.backup_policy,
  })
}

data "aws_iam_policy_document" "ad_assume_role_policy" {
  count = var.domain_id != null && var.domain_iam_role_name == null ? 1 : 0
  statement {
    sid     = "AssumeRole"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ad" {
  count                 = var.domain_id != null && var.domain_iam_role_name == null ? 1 : 0
  name                  = local.domain_role_name
  description           = "Role used by RDS for Active Directory"
  force_detach_policies = true
  assume_role_policy    = data.aws_iam_policy_document.ad_assume_role_policy[count.index].json
  tags                  = local.tags
}

resource "aws_iam_role_policy_attachment" "ad" {
  count      = var.domain_id != null && var.domain_iam_role_name == null ? 1 : 0
  role       = aws_iam_role.ad[count.index].id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSDirectoryServiceAccess"
}

module "db" {
  count                               = var.create ? 1 : 0
  source                              = "terraform-aws-modules/rds/aws"
  version                             = "6.6.0"
  allocated_storage                   = var.allocated_storage
  availability_zone                   = var.availability_zone
  allow_major_version_upgrade         = var.allow_major_version_upgrade
  apply_immediately                   = var.apply_immediately
  auto_minor_version_upgrade          = var.auto_minor_version_upgrade
  backup_retention_period             = var.backup_retention_period
  backup_window                       = var.backup_window
  ca_cert_identifier                  = var.ca_cert_identifier
  character_set_name                  = var.character_set_name
  copy_tags_to_snapshot               = var.copy_tags_to_snapshot
  create_db_option_group              = false
  create_db_parameter_group           = false
  create_db_subnet_group              = true
  create_monitoring_role              = var.create_monitoring_role
  db_instance_tags                    = local.tags
  db_name                             = var.database_name
  db_subnet_group_description         = "Subnet group for ${var.instance_name}. Managed by Terraform."
  db_subnet_group_name                = var.instance_name
  db_subnet_group_use_name_prefix     = var.db_subnet_group_use_name_prefix
  deletion_protection                 = var.deletion_protection
  domain                              = var.domain_id
  domain_iam_role_name                = var.domain_id == null ? null : var.domain_iam_role_name != null ? var.domain_iam_role_name : join("", aws_iam_role.ad.*.name)
  enabled_cloudwatch_logs_exports     = ["agent", "error"]
  engine                              = var.engine
  engine_version                      = var.engine_version
  family                              = var.parameter_group_family
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  identifier                          = var.instance_name
  instance_class                      = var.instance_class
  iops                                = var.iops == 0 ? null : var.iops
  kms_key_id                          = var.kms_key_id
  license_model                       = var.license_model
  maintenance_window                  = var.maintenance_window
  major_engine_version                = var.major_engine_version
  manage_master_user_password         = var.manage_master_user_password
  max_allocated_storage               = var.max_allocated_storage
  monitoring_interval                 = var.monitoring_interval
  monitoring_role_name                = var.monitoring_role_name == null ? "${var.instance_name}-monitoring-role" : var.monitoring_role_name
  multi_az                            = var.multi_az
  option_group_name                   = aws_db_option_group.mssql_rds.name
  parameter_group_name                = aws_db_parameter_group.db_parameter_group[count.index].name
  password                            = var.store_master_password_as_secret && var.generate_random_password ? random_password.root_password[count.index].result : null
  performance_insights_enabled        = var.performance_insights_enabled
  performance_insights_kms_key_id     = var.performance_insights_kms_key_id
  port                                = var.port
  publicly_accessible                 = var.publicly_accessible
  skip_final_snapshot                 = var.skip_final_snapshot
  snapshot_identifier                 = var.snapshot_identifier
  storage_encrypted                   = true
  storage_type                        = var.storage_type
  subnet_ids                          = var.subnets
  tags                                = local.tags
  timezone                            = var.timezone
  username                            = var.username
  vpc_security_group_ids              = [aws_security_group.db_security_group[count.index].id]
  timeouts = {
    create = "${var.db_instance_create_timeout}m"
    update = "${var.db_instance_update_timeout}m"
    delete = "${var.db_instance_delete_timeout}m"
  }
  depends_on = [
    aws_iam_role_policy_attachment.ad,
  ]
}

resource "aws_db_parameter_group" "db_parameter_group" {
  count       = var.create ? 1 : 0
  name_prefix = var.instance_name
  description = "Terraform managed parameter group for ${var.instance_name}"
  family      = var.parameter_group_family
  tags        = local.tags
  dynamic "parameter" {
    for_each = var.db_parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }
}

#-----------------------------------------------------------------------------
# these 4 objects below define the root secret.

resource "aws_secretsmanager_secret" "db" {
  count       = var.create && var.store_master_password_as_secret ? 1 : 0
  name_prefix = "database/${var.instance_name}/master-"
  description = "Master password for ${var.username} in ${var.instance_name}"
  tags        = local.tags
}

resource "aws_secretsmanager_secret_version" "db" {

  count     = var.create && var.store_master_password_as_secret && var.generate_random_password ? 1 : 0
  secret_id = aws_secretsmanager_secret.db[count.index].id
  secret_string = jsonencode({
    "username"       = var.username
    "password"       = random_password.root_password[count.index].result
    "host"           = module.db[count.index].db_instance_address
    "port"           = module.db[count.index].db_instance_port
    "dbname"         = "master"
    "connect_string" = "${module.db[count.index].db_instance_address},${module.db[count.index].db_instance_port}"
    "engine"         = "mssql"
  })
}

resource "random_password" "root_password" {
  count = var.create && var.store_master_password_as_secret && var.generate_random_password ? 1 : 0

  length  = var.random_password_length
  special = false
  numeric = false
}

data "aws_secretsmanager_secret_version" "db" {
  count = var.create && var.store_master_password_as_secret ? 1 : 0

  # There will only ever be one password here. Hard coding the index.
  secret_id  = aws_secretsmanager_secret.db[count.index].id
  depends_on = [aws_secretsmanager_secret_version.db]
}

#-----------------------------------------------------------------------------

resource "aws_security_group" "db_security_group" {
  count  = var.create ? 1 : 0
  name   = var.instance_name
  vpc_id = var.vpc_id
  tags   = local.tags

  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidrs
  }

  dynamic "ingress" {
    for_each = var.security_group_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.ingress_cidrs
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.egress_cidrs
  }
}

# Define the option group explicitly.
resource "aws_db_option_group" "mssql_rds" {

  dynamic "option" {
    for_each = { for u in var.db_options : u["option_name"] => u }
    content {
      option_name                    = option.value["option_name"]
      port                           = option.value["port"]
      version                        = option.value["version"]
      db_security_group_memberships  = option.value["db_security_group_memberships"]
      vpc_security_group_memberships = option.value["vpc_security_group_memberships"]
      dynamic "option_settings" {
        for_each = option.value["option_settings"]

        content {
          name  = option_settings.value["name"]
          value = option_settings.value["value"]
        }
      }
    }
  }

  name_prefix              = var.instance_name
  option_group_description = "MSSQL RDS Option Group managed by Terraform."
  engine_name              = var.engine
  major_engine_version     = var.major_engine_version
  tags                     = local.tags

}

################################################################################
# Create an IAM role to allow access to the s3 data archive bucket
################################################################################

resource "aws_db_instance_role_association" "s3_data_archive" {
  count                  = var.create && var.archive_bucket_name != null && var.share_to_nonprod_account != null ? 1 : 0
  db_instance_identifier = var.instance_name
  feature_name           = "S3_INTEGRATION"
  role_arn               = join("", aws_iam_role.s3_data_archive.*.arn)
  depends_on             = [module.db]
}

resource "aws_iam_role" "s3_data_archive" {
  count              = var.create && var.archive_bucket_name != null && var.share_to_nonprod_account != null ? 1 : 0
  name               = "s3-data-archive-${lower(var.instance_name)}"
  assume_role_policy = join("", data.aws_iam_policy_document.assume_s3_data_archive_role_policy.*.json)
  tags               = local.tags

}

resource "aws_iam_role_policy_attachment" "s3_data_archive" {
  count = var.create && var.archive_bucket_name != null && var.share_to_nonprod_account != null ? 1 : 0
  role  = join("", aws_iam_role.s3_data_archive.*.name)
  # The actions the role can execute
  policy_arn = join("", aws_iam_policy.s3_data_archive[*].arn)
}

resource "aws_iam_policy" "s3_data_archive" {
  count       = var.create && var.archive_bucket_name != null && var.share_to_nonprod_account != null ? 1 : 0
  name        = "s3-data-archive-${lower(var.instance_name)}"
  description = "Terraform managed RDS Instance policy."
  policy      = join("", data.aws_iam_policy_document.exec_s3_data_archive.*.json)
}

data "aws_iam_policy_document" "assume_s3_data_archive_role_policy" {
  count = var.create && var.share_to_nonprod_account != null && var.share_to_nonprod_account != null ? 1 : 0
  source_policy_documents = [
    data.aws_iam_policy_document.assume_s3_data_archive_role_policy_rds[0].json,
    data.aws_iam_policy_document.share_s3_data_archive_sts[count.index].json
  ]
}

data "aws_iam_policy_document" "assume_s3_data_archive_role_policy_rds" {
  count = var.create && var.archive_bucket_name != null && var.share_to_nonprod_account != null ? 1 : 0
  statement {
    actions = [
      "sts:AssumeRole"
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "exec_s3_data_archive" {
  count = var.create && var.archive_bucket_name != null ? 1 : 0
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:GetBucketACL"
    ]
    resources = [
      "arn:aws:s3:::${var.archive_bucket_name}"
    ]
    effect = "Allow"
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListMultipartUploadParts",
      "s3:AbortMultipartUpload"
    ]
    resources = [
      "arn:aws:s3:::${var.archive_bucket_name}/*"
    ]
    effect = "Allow"
  }

  statement {
    actions = [
      "s3:ListAllMyBuckets"
    ]
    resources = [
      "*"
    ]
    effect = "Allow"
  }

  dynamic "statement" {
    for_each = { for a in var.kms_key_id == null ? [] : [var.kms_key_id] : a => a }
    content {
      actions = [
        "kms:Decrypt",
        "kms:Encrypt",
        "kms:DescribeKey",
        "kms:GenerateDataKey"
      ]
      resources = [
        statement.value
      ]
      effect = "Allow"
    }
  }
}
################################################################################
# If a nonprod account number parameter is specified, grant the account number
# read access to the backup destination.

data "aws_iam_policy_document" "share_s3_data_archive_sts" {
  count = var.create && var.share_to_nonprod_account != null ? 1 : 0
  statement {
    sid     = "STSassumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.share_to_nonprod_account}:role/TrueMarkDatabaseAutomation"]
    }
  }
}

data "aws_iam_policy_document" "share_s3_data_archive" {
  count = var.create && var.share_to_nonprod_account != null ? 1 : 0
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]
    resources = [
      "arn:aws:s3:::${var.archive_bucket_name}"
    ]
    effect = "Allow"
  }

  statement {

    actions = [
      "s3:GetObject"
    ]
    resources = [
      "arn:aws:s3:::${var.archive_bucket_name}/*"
    ]
    effect = "Allow"
  }
}

resource "aws_iam_role_policy_attachment" "share_s3_data_archive" {
  count = var.create && var.share_to_nonprod_account != null ? 1 : 0
  role  = join("", aws_iam_role.s3_data_archive.*.name)
  # The actions the role can execute
  policy_arn = join("", aws_iam_policy.share_s3_data_archive[*].arn)
}

resource "aws_iam_policy" "share_s3_data_archive" {
  count       = var.create && var.share_to_nonprod_account != null ? 1 : 0
  name        = "s3-data-archive-share-${lower(var.instance_name)}"
  description = "Terraform managed RDS Instance policy."
  policy      = join("", data.aws_iam_policy_document.share_s3_data_archive.*.json)
}


################################################################################
# Create an IAM policy to attach to the instance role.
# This policy allows access to the s3 bucket for SQL Server Audit.
################################################################################

resource "aws_db_instance_role_association" "audit" {
  count                  = var.create && var.audit_bucket_name != null ? 1 : 0
  db_instance_identifier = var.instance_name
  feature_name           = "SQLSERVER_AUDIT"
  role_arn               = join("", aws_iam_role.audit.*.arn)
  depends_on = [
    aws_iam_role.audit
  ]
}

resource "aws_iam_role" "audit" {
  count              = var.create && var.audit_bucket_name != null ? 1 : 0
  name               = "s3-audit-data-${lower(var.instance_name)}"
  assume_role_policy = join("", data.aws_iam_policy_document.audit_trust.*.json)
  tags               = local.tags
}

resource "aws_iam_role_policy_attachment" "audit" {
  count = var.create && var.audit_bucket_name != null ? 1 : 0
  role  = join("", aws_iam_role.audit.*.name)
  # The actions the role can execute
  policy_arn = join("", aws_iam_policy.audit[*].arn)
}

resource "aws_iam_policy" "audit" {
  count       = var.create && var.audit_bucket_name != null ? 1 : 0
  name        = "s3-audit-data-${lower(var.instance_name)}"
  description = "Terraform managed RDS Instance auditing policy."
  policy      = join("", data.aws_iam_policy_document.audit.*.json)
  tags        = local.tags
}

data "aws_iam_policy_document" "audit_trust" {
  count = var.create && var.audit_bucket_name != null ? 1 : 0
  statement {
    actions = [
      "sts:AssumeRole"
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "audit" {
  count = var.create && var.audit_bucket_name != null ? 1 : 0
  statement {
    actions = [
      "s3:ListAllMyBuckets",
    ]
    resources = [
      "*"
    ]
    effect = "Allow"
  }

  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetBucketACL",
      "s3:GetBucketLocation",
    ]
    resources = [
      "arn:aws:s3:::${var.audit_bucket_name}"
    ]
    effect = "Allow"
  }

  statement {
    actions = [
      "s3:PutObject",
      "s3:ListMultipartUploadParts",
      "s3:AbortMultipartUpload",
    ]
    resources = [
      "arn:aws:s3:::${var.audit_bucket_name}/*"
    ]
    effect = "Allow"
  }
}

data "aws_caller_identity" "current" {}


