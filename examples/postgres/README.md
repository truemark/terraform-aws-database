module "db" {
  source                       = "truemark/database/aws//modules/postgres"
  version                      = ">=0"

  allocated_storage            = 20
  engine_version               = "16.2"
  database_name                = "dbname"
  instance_type                = "db.t3.large"
  max_allocated_storage        = 500
  storage_type                 = "gp3"
  subnet_ids                   = ["subnet-061343678", "subnet-87654321"]
  vpc_id                       = "vpc-01234acffb5bd8" 
}
