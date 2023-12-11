MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="//"

--//
Content-Type: text/x-shellscript; charset="us-ascii"
#!/bin/bash
set -e

CLUSTER_NAME="${cluster_name}"
B64_CLUSTER_CA="${cluster_ca}"
API_SERVER_URL="${endpoint}"
KUBELET_EXTRA_ARGS="${kubelet_extra_args}"
K8S_CLUSTER_DNS_IP="${cluster_dns_ip}"

# MAX PODS Calculate options
MAX_PODS=${max_pods}
USE_CUSTOM_NETWORK=${use_custom_network}
CUSTOM_NETWORK_OPTION="${custom_network_option}"
PREFIX_DELEGATION_OPTION="${prefix_delegation_option}"

# set KUBELET_EXTRA_ARGS
USE_MAX_PODS=true
if $USE_CUSTOM_NETWORK ; then
  USE_MAX_PODS=false
  CNI_VERSION=$(cat /etc/eks/bootstrap.sh | grep cni | awk -F'--cni-version' '{print $2}' | awk -F' ' '{print $1}')
  MAX_PODS=$(/etc/eks/max-pods-calculator.sh --instance-type-from-imds --cni-version $CNI_VERSION --show-max-allowed $CUSTOM_NETWORK_OPTION $PREFIX_DELEGATION_OPTION)
  KUBELET_EXTRA_ARGS="$KUBELET_EXTRA_ARGS --max-pods=$MAX_PODS"
fi

/etc/eks/bootstrap.sh $CLUSTER_NAME --kubelet-extra-args "$KUBELET_EXTRA_ARGS" --b64-cluster-ca "$B64_CLUSTER_CA" --apiserver-endpoint "$API_SERVER_URL" --dns-cluster-ip "$K8S_CLUSTER_DNS_IP" --use-max-pods "$USE_MAX_PODS"
--//--