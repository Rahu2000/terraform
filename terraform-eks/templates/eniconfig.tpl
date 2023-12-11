apiVersion: ${api_version}
kind: ENIConfig
metadata:
  name: ${name}
spec:
  subnet: ${subnet_id}
  securityGroups:
  %{ for sg_id in security_group_ids }
    - ${sg_id}
  %{ endfor ~}