locals {

  aws_sts_endpoint = var.conf.aws.sts_endpoint == "" ? format("sts.%s.amazonaws.com", var.region) : var.conf.aws.sts_endpoint

  opensearch = <<-EOF
  [OUTPUT]
      Name                opensearch
      Match               *
      Host                ${var.conf.outputs.opensearch.endpoint}
      Port                443
      TLS                 On
      AWS_Auth            On
      AWS_Region          ${var.region}
      AWS_STS_Endpoint    ${local.aws_sts_endpoint}
      Retry_Limit         ${var.conf.outputs.opensearch.retry_limit}
      Suppress_Type_Name  ${var.conf.outputs.opensearch.suppress_type_name}
  EOF

  cloudwatch = <<-EOF
  [OUTPUT]
      Name                cloudwatch
      Match               *
      region              ${var.region}
      log_retention_days  ${var.conf.outputs.cloudwatch.log_retention_days}
      endpoint            ${var.conf.outputs.cloudwatch.endpoint}
      AWS_STS_Endpoint    ${local.aws_sts_endpoint}
      log_group_name      ${var.conf.outputs.cloudwatch.log_group}
      log_stream_prefix   ${var.conf.outputs.cloudwatch.log_stream_prefix}
      auto_create_group   On
      retry_limit         2
      workers             1
      %{if var.conf.outputs.cloudwatch.cross_account_role_arn != ""}
      role_arn            ${var.conf.outputs.cloudwatch.cross_account_role_arn}
      %{endif}
  EOF

  stdout = <<-EOF
  [OUTPUT]
    Name                stdout
    Match               *
  EOF

  outputs = [
    { output = (var.conf.outputs.opensearch.enabled ? local.opensearch : "") },
    { output = (var.conf.outputs.cloudwatch.enabled ? local.cloudwatch : "") },
    { output = (var.conf.outputs.stdout.enabled ? local.stdout : "") }
  ]

  enabled_outputs = [for v in local.outputs : v if v.output != ""]

  conf_outputs = length(local.enabled_outputs) == 0 ? "" : <<-EOF
  %{for v in local.enabled_outputs}${v.output}%{endfor}
  EOF
}
