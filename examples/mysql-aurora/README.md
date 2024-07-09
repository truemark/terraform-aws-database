module "db" {
  source              = "truemark/database/aws//modules/mysql-aurora"
  version             = ">=0"

  auto_minor_version_upgrade      = false
  ca_cert_identifier              = "rds-ca-rsa2048-g1"
  db_parameters                   = local.config[data.aws_caller_identity.current.account_id]["db_parameters"]
  db_subnet_group_name            = "mysqlcommon"
  deletion_protection             = false
  engine_version                  = "8.0.mysql_aurora.3.05.2"
  instance_class                  = "db.t4g.large"
  kms_key_id                      = join("", data.aws_kms_alias.db.*.target_key_arn)
  manage_master_user_password     = true
  master_username                 = "admin"
  name                            = local.name
  replica_count                   = local.environment == "prod" ? 1 : 0
  security_group_rules            = local.security_group_rules
  skip_final_snapshot             = true
  store_master_password_as_secret = false
  subnets                         = local.subnets
  tags                            = local.tags
  vpc_id                          = local.vpc_id
}
