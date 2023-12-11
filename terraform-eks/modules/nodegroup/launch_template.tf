locals {
  use_custom_ami = var.eks_node_group_info.ami_id != "" ? true : false
  custom_labels  = [for key, value in var.eks_node_group_info.labels : "${key}=${value}" if key != ""]
  # Set node labels
  labels = flatten([[
    format("eks.amazonaws.com/capacityType=%s", var.eks_node_group_info.capacity_type),
    format("eks.amazonaws.com/nodegroup=%s", var.eks_node_group_info.name),
    format("eks.amazonaws.com/nodegroup-image=%s", var.eks_node_group_info.ami_id)
  ], local.custom_labels])
  taints = [for taint in var.eks_node_group_info.taints : "${taint.key}=${taint.value}:${taint.effect}" if try(taint.key, "") != ""]

  # Set kubelet_extra_args
  kubelet_extra_args = join(" ", [
    length(local.labels) > 0 ? format("--node-labels=%s", join(",", local.labels)) : "",
    length(local.taints) > 0 ? format("--register-with-taints=%s", join(",", local.taints)) : ""
  ])

  cluster_dns_ip = try(var.eks_kubernetes_network_config.service_ipv4_cidr, "") != "" ? cidrhost(var.eks_kubernetes_network_config.service_ipv4_cidr, 10) : ""

  # Set user_data scripts
  custom_user_data = base64encode(templatefile("${path.root}/templates/common_user_data.tpl", {
    cluster_name             = var.eks_cluster_name
    cluster_ca               = var.eks_cluster_certificate_authority_data
    endpoint                 = var.eks_cluster_endpoint
    kubelet_extra_args       = local.kubelet_extra_args
    cluster_dns_ip           = local.cluster_dns_ip
    max_pods                 = var.eks_node_group_info.max_pods
    use_custom_network       = var.custom_network.enable
    custom_network_option    = var.custom_network.enable ? "--cni-custom-networking-enabled" : ""
    prefix_delegation_option = var.custom_network.prefix_delegation.enable ? "--cni-prefix-delegation-enabled" : ""
  }))
}

resource "aws_launch_template" "nodegroup" {
  name                   = var.eks_node_group_info.launch_template_name
  description            = var.eks_node_group_info.description
  update_default_version = true
  image_id               = var.eks_node_group_info.ami_id == "" ? null : var.eks_node_group_info.ami_id

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = var.eks_node_group_info.instance_volume
      volume_type           = "gp3"
      delete_on_termination = true
    }
  }

  instance_type          = var.eks_node_group_info.capacity_type == "SPOT" ? null : var.eks_node_group_info.instance_type
  key_name               = var.key_pair_name
  vpc_security_group_ids = var.vpc_security_group_ids

  monitoring {
    enabled = true
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.common_tags,
      tomap({ "Name" = var.eks_node_group_info.launch_template_name })
    )
  }

  # If you use custom ami, be sure to change `common_user_data.tpl`
  user_data = local.use_custom_ami ? local.custom_user_data : var.eks_node_group_info.user_data

  tags = merge(
    var.common_tags,
    tomap({ "Name" = var.eks_node_group_info.name })
  )

  lifecycle {
    create_before_destroy = true
  }
}
