#!/bin/bash

# Variables
APP_NAME="my_web_app"
REMOTE_SERVER="user@remote_server"
REMOTE_PATH="/var/www/html"
ENVIRONMENT="production"

# Function to build and test the application
function build_and_test() {
    echo "Building and testing the application..."
    npm install
    npm test
}

# Function to package the application
function package_app() {
    echo "Packaging the application..."
    tar czf "$APP_NAME.tar.gz" *
}

# Function to deploy the application to the remote server
function deploy_to_remote() {
    echo "Deploying the application to the remote server..."
    scp "$APP_NAME.tar.gz" "$REMOTE_SERVER:$REMOTE_PATH"
    ssh "$REMOTE_SERVER" "cd $REMOTE_PATH && tar xzf $APP_NAME.tar.gz && rm $APP_NAME.tar.gz"
}

# Main script
echo "Starting custom build and deployment workflow for $ENVIRONMENT environment..."

# Build and test the application
build_and_test

# Package the application
package_app

# Deploy the application to the remote server
deploy_to_remote

echo "Build and deployment to $ENVIRONMENT environment completed successfully."
