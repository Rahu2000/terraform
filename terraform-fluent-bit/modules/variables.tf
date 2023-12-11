variable "project" {
  type        = string
  default     = ""
  description = "project code which used to compose the resource name"
}

variable "env" {
  type        = string
  default     = ""
  description = "environment: dev, stg, qa, prod "
}

variable "region" {
  type        = string
  default     = ""
  description = "aws region"
}

variable "common_tags" {
  type        = map(any)
  default     = {}
  description = "tags for fluent-bit"
}

variable "cluster_name" {
  type        = string
  default     = ""
  description = "cluster name"
}

variable "account_id" {
  type        = string
  default     = ""
  description = "account id"
}

variable "oidc_provider" {
  type = object({
    arn      = string
    url      = string
    provider = optional(string, "aws")
  })

  description = "openid connect provider"
}

variable "helm_chart" {
  type = object({
    name           = string
    repository_url = string
  })
}

variable "helm_release" {
  type = object({
    name          = string
    chart_version = optional(string, "")

    namespace = optional(object({
      create = optional(bool, false)
      name   = optional(string, "logging")
    }))

    service_account = object({
      create = optional(bool, false)
      name   = optional(string, "fluent-bit")
      iam = object({
        create      = optional(bool, false)
        role_name   = optional(string, "")
        policy_name = optional(string, "")
      })
    })

    sets = optional(list(object({
      key   = string
      value = string
    })), [])

    test_framework_enabled = optional(bool, false)
    log_level              = optional(string, "info")
    service_monitor = optional(object({
      enabled             = optional(bool, false)
      namespace           = optional(string, "")
      prometheus_selector = optional(string, "")
    }), {})
    prometheus = optional(object({
      rule_enabled = optional(bool, false)
    }), {})

    resources                   = optional(string, "")
    replicas                    = optional(number, 2)
    affinity                    = optional(string, "")
    tolerations                 = optional(string, "")
    node_selector               = optional(string, "")
    topology_spread_constraints = optional(string, "")
  })

  description = "helm release"
}

variable "conf" {
  type = object({
    aws = optional(object({
      sts_endpoint = optional(string, "")
    }), {})

    service = optional(object({}), {})

    inputs = optional(object({
      tail = optional(object({
        enabled      = optional(bool, false)
        path         = optional(string, "/var/log/containers/*.log")
        exclude_path = optional(string, "*.gz")
        multiline = optional(object({
          parser = optional(string, "docker, cri")
        }), {})
        tag               = optional(string, "kube.*")
        mem_buf_limit     = optional(string, "5MB")
        buffer_chunk_size = optional(string, "32k")
        buffer_max_size   = optional(string, "32k")
        db                = optional(string, "")
      }), {})
      systemd = optional(object({
        enabled        = optional(bool, false)
        tag            = optional(string, "host.*")
        systemd_filter = optional(string, "_SYSTEMD_UNIT=kubelet.service")
        read_from_tail = optional(string, "On")
        db             = optional(string, "")
      }), {})
    }), {})

    filters = optional(object({
      kubernetes = optional(object({
        enabled = optional(bool, false)
        labels  = optional(string, "On")
        logging = optional(object({
          parser  = optional(string, "Off")
          exclude = optional(string, "Off")
        }), {})
        buffer_size = optional(string, "32k")
      }), {})
      multiline = optional(object({
        enabled = optional(bool, false)
        parser  = optional(string, "java")
      }), {})
    }), {})

    outputs = optional(object({
      opensearch = optional(object({
        enabled            = optional(bool, false)
        endpoint           = optional(string, "")
        retry_limit        = optional(number, 6)
        suppress_type_name = optional(string, "Off")
        aws = optional(object({
          policy_name = optional(string, "")
          domain_arn  = optional(string, "")
        }), {})
      }), {})

      cloudwatch = optional(object({
        enabled                = optional(bool, false)
        endpoint               = optional(string, "")
        cross_account_role_arn = optional(string, "")
        log_retention_days     = optional(number, 0)
        log_group              = optional(string, "")
        log_stream_prefix      = optional(string, "")
        aws = optional(object({
          policy_name = optional(string, "")
        }), {})
      }), {})

      stdout = optional(object({
        enabled = optional(bool, false)
      }), {})
    }), {})

    custom_parsers = optional(object({
      springboot = optional(object({
        enabled = optional(bool, false)
      }), {})
    }), {})
  })

  default     = {}
  description = "fluent-bit data pipeline configure"
}
