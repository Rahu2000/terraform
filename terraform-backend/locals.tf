locals {
  common_tags = merge(var.default_tags, {
    "project"    = var.project
    "env"        = var.env
    "org"        = var.org
    "managed by" = "terraform"
  })
}
