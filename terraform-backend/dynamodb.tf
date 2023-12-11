locals {
  DYNAMODB_HASH_KEY       = "LockID"
  DYNAMODB_BILLING_MODE   = "PAY_PER_REQUEST"
  DYNAMODB_ATTRIBUTE_TYPE = "S"
}

# DynamoDB tables for Terraform concurrency locking
resource "aws_dynamodb_table" "tables" {
  for_each = toset(var.dynamo_tables)
  name     = format("%s-%s-%s-%s-%s", var.project, var.env, var.org, each.key, var.abbr_region)

  hash_key     = local.DYNAMODB_HASH_KEY
  billing_mode = local.DYNAMODB_BILLING_MODE

  attribute {
    name = local.DYNAMODB_HASH_KEY
    type = local.DYNAMODB_ATTRIBUTE_TYPE
  }

  tags = merge(
    local.common_tags,
    tomap({ Name = format("%s-%s-%s-%s-%s", var.project, var.env, var.org, each.key, var.abbr_region) })
  )

  provider = aws.SHARED
}
