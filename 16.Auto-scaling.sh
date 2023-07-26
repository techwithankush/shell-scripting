#!/bin/bash

# Set the target CPU utilization percentage for auto-scaling actions
CPU_THRESHOLD=80

# Function to get the current CPU utilization
function get_cpu_utilization() {
    cpu_utilization=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
    echo "$cpu_utilization"
}

# Function to scale up
function scale_up() {
    # Put your scaling-up logic here
    # For AWS EC2 Auto Scaling, you would use the 'aws autoscaling set-desired-capacity' command
    echo "Scaling up..."
}

# Function to scale down
function scale_down() {
    # Put your scaling-down logic here
    # For AWS EC2 Auto Scaling, you would use the 'aws autoscaling set-desired-capacity' command
    echo "Scaling down..."
}

# Main script
while true; do
    cpu_utilization=$(get_cpu_utilization)
    echo "Current CPU Utilization: ${cpu_utilization}%"

    if (( $(echo "$cpu_utilization >= $CPU_THRESHOLD" | bc -l) )); then
        # Scale up if CPU utilization exceeds the threshold
        scale_up
    else
        # Scale down if CPU utilization is below the threshold
        scale_down
    fi

    # Sleep for a while before checking again
    sleep 60
done
