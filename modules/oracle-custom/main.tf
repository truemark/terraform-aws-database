locals {
  tags = merge(var.tags,
    {
      "automation:component-id"     = "rds-custom-oracle",
      "automation:component-url"    = "https://registry.terraform.io/modules/truemark/database/aws/latest/submodules/oracle-custom",
      "automation:component-vendor" = "TrueMark",
      "backup:policy"               = "default-week",
  })
}

module "db" {
  # https://registry.terraform.io/modules/terraform-aws-modules/rds/aws/latest
  # https://github.com/terraform-aws-modules/terraform-aws-rds/blob/v3.3.0/examples/complete-oracle/main.tf
  source  = "terraform-aws-modules/rds/aws"
  version = "6.5.4"

  # The name of the database to create. Upper is required by Oracle.
  # Can't be more than 8 characters.
  db_name = upper(var.database_name)

  #-----------------------------------------------------------------------------
  # Define references to the parameter group. This module does not create it.
  create_db_parameter_group = var.create_db_parameter_group
  # When this rds/aws module is set to create a default parameter group,
  # it takes the name parameter above and uses it
  # to create the parameter group name. This parameter group name can't be
  # capitalized. However, Oracle requires that the database
  # name be capitalized. Therefore, I'm hard coding the
  # parameter group name.
  parameter_group_name = null
  # Yes, the parameter is "parameter_group_name", and yes, the corresponding
  # Terraform parameter is "id". Yes, it's confusing.
  #-----------------------------------------------------------------------------

  # parameter_group_use_name_prefix = false
  allocated_storage           = var.allocated_storage
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  apply_immediately           = var.apply_immediately
  backup_retention_period     = var.backup_retention_period
  ca_cert_identifier          = var.ca_cert_identifier
  copy_tags_to_snapshot       = var.copy_tags_to_snapshot
  create_db_option_group      = var.create_db_option_group # not used in custom set to false
  create_db_subnet_group      = var.create_db_subnet_group
  custom_iam_instance_profile = var.custom_iam_instance_profile
  db_instance_tags            = local.tags
  db_subnet_group_description = "Subnet group for ${var.instance_name}. Managed by Terraform."
  db_subnet_group_name        = var.db_subnet_group_name != null ? var.db_subnet_group_name : var.instance_name
  db_subnet_group_tags        = local.tags
  deletion_protection         = var.deletion_protection
  engine                      = var.engine
  engine_version              = var.engine_version
  family                      = var.family
  identifier                  = var.instance_name
  instance_class              = var.instance_type
  iops                        = var.master_iops
  kms_key_id                  = var.kms_key_id
  license_model               = var.license_model
  maintenance_window          = var.preferred_maintenance_window
  major_engine_version        = var.major_engine_version
  manage_master_user_password = false # not supported in custom
  option_group_name           = var.instance_name
  options                     = var.db_options
  option_group_description    = var.option_group_description
  password                    = var.store_master_password_as_secret ? random_password.root_password.result : null
  skip_final_snapshot         = var.skip_final_snapshot
  snapshot_identifier         = var.snapshot_identifier
  storage_encrypted           = true
  storage_type                = var.storage_type
  subnet_ids                  = var.subnet_ids
  tags                        = local.tags
  username                    = var.master_username
  vpc_security_group_ids      = [aws_security_group.db_security_group.id]

  timeouts = {
    create = "${var.db_instance_create_timeout}m"
    update = "${var.db_instance_update_timeout}m"
    delete = "${var.db_instance_delete_timeout}m"
  }
}

#-----------------------------------------------------------------------------
resource "aws_secretsmanager_secret" "db" {
  count       = var.store_master_password_as_secret ? 1 : 0
  name_prefix = "database/${var.instance_name}/master-"
  description = "Master password for ${var.master_username} in ${var.instance_name}"
  tags        = local.tags
}

resource "aws_secretsmanager_secret_version" "db" {
  count     = var.store_master_password_as_secret ? 1 : 0
  secret_id = aws_secretsmanager_secret.db[count.index].id
  secret_string = jsonencode({
    "username"       = var.master_username
    "password"       = var.password != null ? var.password : random_password.root_password.result
    "host"           = module.db.db_instance_address
    "port"           = module.db.db_instance_port
    "dbname"         = module.db.db_instance_name
    "connect_string" = "${module.db.db_instance_endpoint}/${upper(var.instance_name)}"
    "engine"         = "oracle"
  })
}
resource "random_password" "root_password" {
  length  = var.random_password_length
  special = false
  # An Oracle password cannot start with a number.
  # There is no way to tell Terraform to create a password that starts
  # with a character only that I am aware of, so don't use
  # numbers at all. Same with special characters (Oracle only allows #, but a pw
  # can't start with #).
  numeric = false
}

data "aws_secretsmanager_secret_version" "db" {
  count = var.store_master_password_as_secret ? 1 : 0
  # There will only ever be one password here. Hard coding the index.
  secret_id  = aws_secretsmanager_secret.db[0].id
  depends_on = [aws_secretsmanager_secret_version.db]
}

#-----------------------------------------------------------------------------

resource "aws_security_group" "db_security_group" {
  name   = var.instance_name
  vpc_id = var.vpc_id
  tags   = local.tags

  ingress {
    from_port   = 1521
    to_port     = 1521
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidrs
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidrs
  }

  ingress {
    from_port   = 3872
    to_port     = 3872
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidrs
  }

  # TODO Lock this down later
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = var.ingress_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = var.egress_cidrs
  }
}



