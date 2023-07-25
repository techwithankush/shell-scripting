#!/bin/bash

# Define variables
APP_NAME="my-node-app"  # Replace with your application name
APP_DIR="/path/to/your/application"  # Replace with the path to your application directory
TARGET_SERVERS=("server1.example.com" "server2.example.com")  # Replace with the IP addresses or hostnames of your target servers

# Create the temporary deployment directory on the local machine
TMP_DEPLOY_DIR=$(mktemp -d)

# Copy application files to the temporary deployment directory
cp -r $APP_DIR/* $TMP_DEPLOY_DIR/

# Ansible playbook to deploy the application
cat > $TMP_DEPLOY_DIR/deploy.yml <<EOF
---
- hosts: all
  tasks:
    - name: Copy application files to the remote server
      copy:
        src: "{{ playbook_dir }}"
        dest: "/var/www/{{ app_name }}"
        remote_src: yes
      become: yes
      become_user: your_remote_user
      vars:
        app_name: "$APP_NAME"
EOF

# Run the Ansible playbook
ansible-playbook -i "${TARGET_SERVERS[*]}," -u your_remote_user --private-key /path/to/your/ssh/key.pem $TMP_DEPLOY_DIR/deploy.yml

# Remove the temporary deployment directory
rm -rf $TMP_DEPLOY_DIR

echo "Application deployed successfully!"
