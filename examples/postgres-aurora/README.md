module "db" {
  source                          = "truemark/database/aws//modules/aurora-postgres"
  version                         = ">=0"
  database_name                   = "dbname"
  deletion_protection             = true
  engine_version                  = "14.6"
  family                          = "aurora-postgresql14"
  instance_class                  = "db.r6g.2xlarge"
  name                            = "dbname"
  replica_count                   = 0
  subnets                         = [ "subnet-0613436966e999", "subnet-0613436966ea998" ]
  vpc_id                          = "vpc-0a6c8fae7776adb32"
}
