#Sending Notifications: Use shell scripts to send notifications via email, Slack, or other messaging platforms to keep team members informed about important events.
#!/bin/bash

# Send a notification via email
echo "Important update: The application deployment to production was successful." | mail -s "Deployment Notification" team@example.com

# Send a notification to Slack using webhook URL
SLACK_WEBHOOK_URL="https://hooks.slack.com/services/XXXXXXXXX/XXXXXXXXX/XXXXXXXXXXXXXXXXXXXXXXXX"
slack_message="Important update: The application deployment to production was successful."
curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"$slack_message\"}" $SLACK_WEBHOOK_URL

_____________________________________________________________________________________________________________________

#Backup to Cloud Storage: Automate data backups to cloud storage services like AWS S3 or Google Cloud Storage.
#!/bin/bash

# Backup a directory to AWS S3 bucket
AWS_ACCESS_KEY="YOUR_ACCESS_KEY"
AWS_SECRET_KEY="YOUR_SECRET_KEY"
S3_BUCKET="my-backup-bucket"
BACKUP_DIR="/path/to/backup"

aws s3 sync $BACKUP_DIR s3://$S3_BUCKET --access-key $AWS_ACCESS_KEY --secret-key $AWS_SECRET_KEY
_____________________________________________________________________________________________________________________

#Automating Deployments: Use shell scripts to automate deployments by interacting with deployment tools like Jenkins or Ansible.
#!/bin/bash

# Trigger a Jenkins job
JENKINS_URL="https://jenkins.example.com"
JENKINS_JOB_NAME="my_app_deploy"
JENKINS_TOKEN="YOUR_JENKINS_JOB_TOKEN"

curl -X POST $JENKINS_URL/job/$JENKINS_JOB_NAME/build?token=$JENKINS_TOKEN

_____________________________________________________________________________________________________________________

#API Interactions: Use shell scripts to interact with REST APIs and perform various actions, such as data retrieval or updates.
#!/bin/bash

# Interact with GitHub API to get repository information
GITHUB_API_TOKEN="YOUR_GITHUB_API_TOKEN"
REPO_OWNER="myusername"
REPO_NAME="my_repository"

curl -H "Authorization: token $GITHUB_API_TOKEN" https://api.github.com/repos/$REPO_OWNER/$REPO_NAME

_____________________________________________________________________________________________________________________

#Monitoring and Metrics: Use shell scripts to fetch and process metrics from monitoring tools or APIs.
#!/bin/bash

# Fetch CPU usage metrics from Prometheus API
PROMETHEUS_URL="https://prometheus.example.com/api/v1/query"
QUERY="100 - (avg by (instance) (irate(node_cpu_seconds_total{mode='idle'}[5m])) * 100)"

curl -G $PROMETHEUS_URL --data-urlencode "query=$QUERY"




