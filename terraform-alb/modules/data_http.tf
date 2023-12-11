# Get crds for aws-load-balancer-controller
data "http" "crds" {
  url = local.CRDS_URL
  request_headers = {
    Accept = "text/plain"
  }
}

# Get iam policy for aws-load-balancer-controller
data "http" "iam_policy" {
  url = local.IAM_POLICY_URL
  request_headers = {
    Accept = "text/plain"
  }
}
