output "s3_bucket" {
  value = var.create_s3_bucket ? aws_s3_bucket.this[0].bucket : var.s3_bucket_name
}

output "dynamodb_tables" {
  value = values(aws_dynamodb_table.tables)[*].name
}
