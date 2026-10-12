mock_provider "aws" {
  override_data {
    target = data.aws_kms_key.db
    values = {
      arn = "arn:aws:kms:us-east-1:111111111111:key/from-kms-key-id"
    }
  }

  override_data {
    target = data.aws_kms_alias.db
    values = {
      target_key_arn = "arn:aws:kms:us-east-1:111111111111:key/from-kms-key-alias"
    }
  }

  override_data {
    target = data.aws_iam_policy_document.rds_enhanced_monitoring
    values = {
      json = "{}"
    }
  }
}

mock_provider "random" {}

variables {
  instance_name = "test-mysql"
  vpc_id        = "vpc-00000000"
  subnet_ids    = ["subnet-00000000", "subnet-11111111"]
}

run "no_key_uses_rds_default" {
  command = plan

  assert {
    condition     = local.kms_key_arn == null
    error_message = "With no key configured the RDS default key should be used"
  }
}

run "kms_key_arn" {
  command = plan

  variables {
    kms_key_arn = "arn:aws:kms:us-east-1:111111111111:key/explicit-arn"
    kms_key_id  = "alias/ignored"
  }

  assert {
    condition     = local.kms_key_arn == "arn:aws:kms:us-east-1:111111111111:key/explicit-arn"
    error_message = "kms_key_arn should override kms_key_id and kms_key_alias"
  }
}

run "kms_key_id" {
  command = plan

  variables {
    kms_key_id    = "0b8a1f4e-3c2d-4e5f-9a8b-7c6d5e4f3a2b"
    kms_key_alias = "alias/ignored"
  }

  assert {
    condition     = local.kms_key_arn == "arn:aws:kms:us-east-1:111111111111:key/from-kms-key-id"
    error_message = "kms_key_id should be resolved to a key ARN and override kms_key_alias"
  }
}

run "kms_key_alias" {
  command = plan

  variables {
    kms_key_alias = "alias/mysql-db"
  }

  assert {
    condition     = local.kms_key_arn == "arn:aws:kms:us-east-1:111111111111:key/from-kms-key-alias"
    error_message = "kms_key_alias should be resolved to its target key ARN"
  }
}
