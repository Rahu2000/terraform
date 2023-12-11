locals {
  # The springboot parser is not currently supported.
  springboot = <<-EOF
  [PARSER]
      Name        springboot
      Format      regex
      Regex       /^(?<time>\d{4}-\d{1,2}-\d{1,2}T\d{1,2}:\d{1,2}:\d{1,2}\.\d+(Z|[\+\-]\d{2}(:\d{2})?))\s+(?<logLevel>TRACE|DEBUG|INFO|WARN?(?:ING)?|ERR?(?:OR)?|CRIT?(?:ICAL)?|FATAL|SEVERE?)/
      Time_Key    time
      Time_Format %Y-%m-%dT%H:%M:%S.%L%z
  EOF

  parsers = [
    { parser = (var.conf.custom_parsers.springboot.enabled ? local.springboot : "") }
  ]

  enabled_parsers = [for v in local.parsers : v if v.parser != ""]

  conf_parsers = length(local.enabled_parsers) == 0 ? "" : <<-EOF
  %{for v in local.enabled_parsers}${v.parser}%{endfor}
  EOF
}
