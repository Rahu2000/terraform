variable "project" {
  type        = string
  default     = ""
  description = "project code or corporate code"
}

variable "region" {
  type        = string
  default     = ""
  description = "aws region e.g. ap-northeast-2"
}

variable "abbr_region" {
  type        = string
  default     = ""
  description = "abbreviation of aws region. e.g. AN2"
}

variable "env" {
  type        = string
  default     = ""
  description = "environment: dev, stg, qa, prod "
}

variable "org" {
  type        = string
  default     = ""
  description = "organization name"
}

variable "default_tags" {
  default = {}
}

variable "dynamo_tables" {
  type        = list(string)
  default     = []
  description = "list of dynamo's table for terraform lock"
}

variable "create_s3_bucket" {
  type        = bool
  default     = true
  description = "s3 bucket name to store the terraform state"
}

variable "s3_bucket_name" {
  type        = string
  default     = ""
  description = "s3 bucket name to store the terraform state"
}

variable "enable_encrypt" {
  type        = bool
  default     = false
  description = "enable s3 bucket encrypt. the default sse_algorithm is `AES256`"
}

variable "shared_account" {
  type = object({
    region          = string
    profile         = optional(string, "")
    assume_role_arn = optional(string, "")
  })
  description = "default account"
}

variable "target_account" {
  type = object({
    region          = string
    profile         = optional(string, "")
    assume_role_arn = optional(string, "")
  })
  description = "target account"
}
