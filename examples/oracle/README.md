module "db" {
  source                          = "truemark/database/aws//modules/oracle"
  version                         = ">0"
  
  database_name                   = "DBNAME"
  allocated_storage               = 100
  archive_bucket_name             = "my-archive-bucket-name"
  auto_minor_version_upgrade      = false
  deletion_protection             = true
  engine                          = "oracle-se2"
  engine_version                  = "19.0.0.0.ru-2022-01.rur-2022-01.r1"
  family                          = "oracle-se2-19"
  instance_name                   = local.name
  instance_type                   =  "db.m6i.large" 
  license_model                   = "bring-your-own-license"
  major_engine_version            = "19"
  monitoring_interval             = 60
  multi_az                        = false
  random_password_length          = 16
  skip_final_snapshot             = false
  subnet_ids                      = [ "subnet-0613436966e999", "subnet-0613436966ea998" ]
  vpc_id                          = "vpc-0a6c8fae7776adb32"
  
    
  

  allocated_storage               = 100
  auto_minor_version_upgrade      = false
  archive_bucket_name             = "my-archive-bucket-name"
  ca_cert_identifier              = "rds-ca-rsa2048-g1"
  create_db_option_group          = true
  database_name = "DB_NAME"
  db_options = [
    {
      option_name = "Timezone",
      option_settings = [{
        name  = "TIME_ZONE"
        value = "America/Denver"
      }]
    }
  ]
  db_parameters = [
    {
      name         = "recyclebin"
      value        = "ON"
      apply_method = "pending-reboot"
    }
  ]
  deletion_protection             = true
  engine                          = "oracle-ee"
  family                          = "oracle-ee-19"
  engine_version                  = "19.0.0.0.ru-2023-01.rur-2023-01.r2"
  ingress_cidrs                   = ["10.0.0.0/8"]
  instance_name                   = "INSTANCE_NAME"
  instance_type                   = "db.r6i.xlarge"
  kms_key_id                      = "alias/shared"
  license_model                   = "bring-your-own-license" #"license-included" # bring-your-own-license
  major_engine_version            = "19"
  manage_master_user_password     = false
  max_allocated_storage           = 500
  master_iops                     = 12000
  monitoring_interval             = 60
  multi_az                        = false
  preferred_maintenance_window    = "sun:12:00-sun:14:00"
  preferred_backup_window         = "03:00-05:00"
  random_password_length          = 16
  skip_final_snapshot             = false
  storage_type                    = "io1"
  subnet_ids                      = ["subnet-0613436966e999", "subnet-0613436966ea998"]
  tags = {
    "owner"                       = "owner_name"
    "description"                 = "description"
  }
  vpc_id                          = data.aws_vpc.main.id
}
