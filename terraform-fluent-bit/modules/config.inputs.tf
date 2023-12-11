locals {
  tail = <<-EOF
  [INPUT]
      Name                tail
      Path                ${var.conf.inputs.tail.path}
      Exclude_Path        ${var.conf.inputs.tail.exclude_path}
      multiline.parser    ${var.conf.inputs.tail.multiline.parser}
      Tag                 ${var.conf.inputs.tail.tag}
      Mem_Buf_Limit       ${var.conf.inputs.tail.mem_buf_limit}
      Skip_Long_Lines     On
      Skip_Empty_Lines    On
      Buffer_Chunk_Size   ${var.conf.inputs.tail.buffer_chunk_size}
      Buffer_Max_Size     ${var.conf.inputs.tail.buffer_max_size}
      %{if var.conf.inputs.tail.db != ""}
      DB                  ${var.conf.inputs.tail.db}
      %{endif}
  EOF

  systemd = <<-EOF
  [INPUT]
      Name                systemd
      Tag                 ${var.conf.inputs.systemd.tag}
      Systemd_Filter      ${var.conf.inputs.systemd.systemd_filter}
      Read_From_Tail      ${var.conf.inputs.systemd.read_from_tail}
      %{if var.conf.inputs.systemd.db != ""}
      DB                  ${var.conf.inputs.systemd.db}
      %{endif}
  EOF

  inputs = [
    { input = (var.conf.inputs.tail.enabled ? local.tail : "") },
    { input = (var.conf.inputs.systemd.enabled ? local.systemd : "") }
  ]

  enabled_inputs = [for v in local.inputs : v if v.input != ""]

  conf_inputs = length(local.enabled_inputs) == 0 ? "" : <<-EOF
  %{for v in local.enabled_inputs}${v.input}%{endfor}
  EOF
}
