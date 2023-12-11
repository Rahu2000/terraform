# Create S3 bucket for backend
resource "aws_s3_bucket" "this" {
  count  = var.create_s3_bucket ? 1 : 0
  bucket = var.s3_bucket_name

  tags = merge(
    local.common_tags,
    tomap({ "Name" = var.s3_bucket_name })
  )

  force_destroy = true

  provider = aws.SHARED
}

# Enable s3 bucket versioning
# Notice: Once enabled, it cannot be disabled. It just turns into `Suspended`.
resource "aws_s3_bucket_versioning" "this" {
  bucket = var.create_s3_bucket ? aws_s3_bucket.this[0].id : var.s3_bucket_name
  versioning_configuration {
    status = "Enabled"
  }

  provider = aws.SHARED
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count  = var.enable_encrypt ? 1 : 0
  bucket = var.create_s3_bucket ? aws_s3_bucket.this[0].id : var.s3_bucket_name

  rule {
    bucket_key_enabled = true
  }

  provider = aws.SHARED
}

resource "aws_s3_bucket_policy" "this" {
  count  = var.enable_encrypt ? 1 : 0
  bucket = var.create_s3_bucket ? aws_s3_bucket.this[0].id : var.s3_bucket_name
  policy = data.aws_iam_policy_document.this.json

  provider = aws.SHARED
}

data "aws_iam_policy_document" "this" {
  statement {
    sid    = "DenyUnEncryptedObjectUploads"
    effect = "Deny"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${var.s3_bucket_name}/*"]
    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["AES256"]
    }
  }

  statement {
    sid    = "DenyInsecureConnections"
    effect = "Deny"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions   = ["s3:*"]
    resources = ["arn:aws:s3:::${var.s3_bucket_name}/*"]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}
