#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

read -p "aws profile to use: " profile
read -p "Enter the cluster name: " CLUSTER_NAME
read -p "Enter the policy name: " POLICY_NAME

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

cat <<EOF > "$SCRIPT_DIR/cluster-autoscaler-policy.json"
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "aws:ResourceTag/k8s.io/cluster-autoscaler/<cluster name>": "owned"
                }
            }
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeTags",
                "ec2:DescribeInstanceTypes",
                "ec2:DescribeLaunchTemplateVersions"
            ],
            "Resource": "*"
        }
    ]
}
EOF

echo "cluster-autoscaler-policy.json created."

echo "Creating IAM policy..."

aws_response=$(aws iam create-policy --profile $profile --policy-name $POLICY_NAME --policy-document file://cluster-autoscaler-policy.json)
POLICY_ARN=$(echo $aws_response | grep -o '"Arn": *"[^"]*' | grep -o '[^"]*$')

echo "IAM policy created: $POLICY_ARN"

echo "Associating IAM OIDC provider..."

eksctl utils associate-iam-oidc-provider --profile=$profile --region=ap-south-1 --cluster=$CLUSTER_NAME --approve
echo "IAM OIDC provider associated."

echo "Creating service account..."

if [ -z "$POLICY_ARN" ]; then
    echo "Error: Failed to fetch policy ARN. Please check IAM policy creation."
else
    eksctl create iamserviceaccount \
      --profile=$profile \
      --cluster=$CLUSTER_NAME \
      --namespace=kube-system \
      --name=cluster-autoscaler \
      --attach-policy-arn=$POLICY_ARN \
      --override-existing-serviceaccounts \
      --approve
    echo "Service account created."
fi

echo "Downloading cluster-autoscaler-autodiscover.yaml..."

curl -o cluster-autoscaler-autodiscover.yaml https://raw.githubusercontent.com/kubernetes/autoscaler/master/cluster-autoscaler/cloudprovider/aws/examples/cluster-autoscaler-autodiscover.yaml

echo "cluster-autoscaler-autodiscover.yaml downloaded."

echo "Deploying cluster autoscaler..."

kubectl apply -f cluster-autoscaler-autodiscover.yaml

echo "Cluster autoscaler deployed."

echo "Patching the deployment..."

kubectl patch deployment cluster-autoscaler -n kube-system -p \
'{"spec":{"template":{"spec":{"containers":[{"name":"cluster-autoscaler","command":["./cluster-autoscaler","--v=4","--stderrthreshold=info","--cloud-provider=aws","--skip-nodes-with-local-storage=false","--expander=least-waste","--node-group-auto-discovery=asg:tag=k8s.io/cluster-autoscaler/enabled,k8s.io/cluster-autoscaler/$CLUSTER_NAME","--balance-similar-node-groups","--skip-nodes-with-system-pods=false"]}]}}}}'

echo "Deployment patched."
