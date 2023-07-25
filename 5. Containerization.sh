#!/bin/bash

# Define variables
APP_NAME="my-node-app"  # Replace with your application name
DOCKER_IMAGE_TAG="latest"  # Replace with the desired Docker image tag
DOCKER_CONTAINER_NAME="my-node-container"  # Replace with the desired Docker container name
PORT=3000  # Replace with the port number your application listens on
ENVIRONMENT="production"  # Replace with the desired environment (e.g., development, staging, production)

# Navigate to the application directory
cd /path/to/your/application

# Build the Docker image
docker build -t $APP_NAME:$DOCKER_IMAGE_TAG .

# Check if the Docker container is already running
if [ "$(docker ps -q -f name=$DOCKER_CONTAINER_NAME)" ]; then
    # Stop and remove the existing container
    docker stop $DOCKER_CONTAINER_NAME
    docker rm $DOCKER_CONTAINER_NAME
fi

# Run the Docker container
docker run -d --name $DOCKER_CONTAINER_NAME -p $PORT:3000 \
    -e NODE_ENV=$ENVIRONMENT \
    $APP_NAME:$DOCKER_IMAGE_TAG

echo "Docker container deployed successfully!"
