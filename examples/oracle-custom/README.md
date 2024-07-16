module "db" {
  source                          = "truemark/database/aws//modules/oracle-custom"
  version                         = ">=0"
  
  allocated_storage               = 100
  copy_tags_to_snapshot           = true
  custom_iam_instance_profile     = "AWSRDSCustomInstanceProfileForRdsCustomInstance"
  database_name                   = "DB_NAME"
  db_options = [
    {
      option_name = "Timezone",
      option_settings = [{
        name  = "TIME_ZONE"
        value = "America/Denver"
      }]
    }
  ]
  deletion_protection             = true
  engine                          = "custom-oracle-ee"
  engine_version                  = "19.myoraclecustom19_16"
  instance_name                   = "INSTANCE_NAME"
  instance_type                   = "db.x2iedn.8xlarge"
  family                          = "19"
  kms_key_id                      = "join("", data.aws_kms_alias.db.*.target_key_arn)"
  license_model                   = "bring-your-own-license"
  preferred_maintenance_window    = "sun:12:00-sun:14:00"
  preferred_backup_window         = "03:00-05:00"
  major_engine_version            = "19"
  master_iops                     = 12000
  random_password_length          = 16
  skip_final_snapshot             = true
  storage_type                    = "io1"
  subnet_ids                      = ["subnet-0613436966e999", "subnet-0613436966ea998"]
  tags = {
    "owner"                       = "owner_name"
    "description"                 = "description"
  }
  vpc_id                          = "vpc-0a6c8fae7776adb32"
}
