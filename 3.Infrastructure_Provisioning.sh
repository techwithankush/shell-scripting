#!/bin/bash

# Define variables
REGION="us-east-1"  # Replace with your desired AWS region
INSTANCE_TYPE="t2.micro"  # Replace with the desired instance type
KEY_PAIR_NAME="your-key-pair"  # Replace with the name of your existing EC2 key pair
SECURITY_GROUP_NAME="your-security-group"  # Replace with the name of your existing security group
AMI_ID="your-ami-id"  # Replace with the ID of the Amazon Machine Image (AMI) you want to use

# Create a new EC2 instance
instance_id=$(aws ec2 run-instances --region $REGION \
              --image-id $AMI_ID \
              --instance-type $INSTANCE_TYPE \
              --key-name $KEY_PAIR_NAME \
              --security-groups $SECURITY_GROUP_NAME \
              --query 'Instances[0].InstanceId' \
              --output text)

# Wait until the instance is running
echo "Waiting for instance to be in running state..."
aws ec2 wait instance-running --region $REGION --instance-ids $instance_id
echo "Instance is now running."

# Retrieve the public IP address of the instance
public_ip=$(aws ec2 describe-instances --region $REGION \
            --instance-ids $instance_id \
            --query 'Reservations[0].Instances[0].PublicIpAddress' \
            --output text)

echo "Public IP address: $public_ip"

# (Optional) Additional setup and configuration steps can be added here.

# Display completion message
echo "Instance provisioning completed!"
