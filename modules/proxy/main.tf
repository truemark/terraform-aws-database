data "aws_caller_identity" "current" {}

resource "aws_iam_role" "proxy" {
  count              = var.create_proxy ? 1 : 0
  name               = var.name
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "rds.amazonaws.com"
        ]},
      "Action": [ "sts:AssumeRole" ]
  }]
}
EOF
}

data "aws_iam_policy_document" "proxy" {
  statement {
    sid    = "AllowSecret"
    effect = "Allow"
    actions = [
      "secretsmanager:*"
    ]
    resources = var.secret_arns
  }
  statement {
    sid    = "AllowList"
    effect = "Allow"
    actions = [
      "secretsmanager:GetRandomPassword",
      "secretsmanager:CreateSecret",
      "secretsmanager:ListSecrets"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "AllowDecrypt"
    effect = "Allow"
    actions = [
      "kms:Decrypt"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "proxy" {
  count  = var.create_proxy ? 1 : 0
  name   = var.name
  policy = data.aws_iam_policy_document.proxy.json
}

resource "aws_iam_role_policy_attachment" "proxy" {
  count      = var.create_proxy ? 1 : 0
  policy_arn = aws_iam_policy.proxy[count.index].arn
  role       = aws_iam_role.proxy[count.index].name
}

resource "aws_security_group" "proxy" {
  count       = var.create_proxy && var.create_security_group ? 1 : 0
  name_prefix = "${var.name}-"
  vpc_id      = var.vpc_id
  description = var.security_group_description == "" ? "Control traffic to/from RDS Proxy ${var.name}" : var.security_group_description
  tags = merge(var.tags, var.security_group_tags, {
    Name = "${var.name}-proxy"
  })
}

resource "aws_security_group_rule" "default_ingress" {
  count = var.create_proxy && var.create_security_group ? length(var.allowed_security_groups) : 0

  description = "From allowed SGs"

  type                     = "ingress"
  from_port                = var.engine_family == "POSTGRESQL" ? 5432 : 3306
  to_port                  = var.engine_family == "POSTGRESQL" ? 5432 : 3306
  protocol                 = "tcp"
  source_security_group_id = element(var.allowed_security_groups, count.index)
  security_group_id        = aws_security_group.proxy[count.index].id
}

resource "aws_security_group_rule" "cidr_ingress" {
  count = var.create_proxy && var.create_security_group && length(var.allowed_cidr_blocks) > 0 ? 1 : 0

  description = "From allowed CIDRs"

  type              = "ingress"
  from_port         = var.engine_family == "POSTGRESQL" ? 5432 : 3306
  to_port           = var.engine_family == "POSTGRESQL" ? 5432 : 3306
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidr_blocks
  security_group_id = aws_security_group.proxy[count.index].id
}

resource "aws_security_group_rule" "sgs_egress" {
  count       = var.create_proxy && var.create_security_group ? 1 : 0
  description = "To allowed SGs"
  type        = "egress"
  from_port   = var.engine_family == "POSTGRESQL" ? 5432 : 3306
  to_port     = var.engine_family == "POSTGRESQL" ? 5432 : 3306
  protocol    = "tcp"

  security_group_id        = aws_security_group.proxy[count.index].id
  source_security_group_id = var.rds_security_group_id
}

resource "aws_db_proxy" "proxy" {
  count                  = var.create_proxy ? 1 : 0
  name                   = var.name
  engine_family          = var.engine_family
  debug_logging          = var.debug_logging
  require_tls            = var.require_tls
  idle_client_timeout    = var.idle_client_timeout
  role_arn               = aws_iam_role.proxy[count.index].arn
  vpc_security_group_ids = compact(concat(var.vpc_security_group_ids, aws_security_group.proxy.*.id))
  vpc_subnet_ids         = var.subnets
  tags                   = var.tags
  dynamic "auth" {
    for_each = var.secret_arns
    content {
      auth_scheme = "SECRETS"
      description = "Proxy ${var.name} access to secret ${auth.value}"
      iam_auth    = var.iam_auth
      secret_arn  = auth.value
    }
  }
}

resource "aws_db_proxy_default_target_group" "proxy" {
  count         = var.create_proxy ? 1 : 0
  db_proxy_name = aws_db_proxy.proxy[count.index].name
  connection_pool_config {
    connection_borrow_timeout    = var.connection_borrow_timeout
    init_query                   = var.init_query
    max_connections_percent      = var.max_connections_percent
    max_idle_connections_percent = var.max_idle_connections_percent
    session_pinning_filters      = var.session_pinning_filters
  }
}
# Hello Jim
# TODO Creating the proxy errors because the DB is still in a CREATING state, we need to wait for it
# TODO https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep
resource "aws_db_proxy_target" "proxy" {
  count                  = var.create_proxy ? 1 : 0
  db_cluster_identifier  = var.db_cluster_identifier
  db_instance_identifier = var.db_instance_identifier
  db_proxy_name          = aws_db_proxy.proxy[count.index].name
  target_group_name      = "default"
}
