#!/bin/bash

# Monitoring interval (in seconds)
INTERVAL=5

# Function to monitor CPU and memory usage
function monitor_server() {
    echo "Monitoring CPU and memory usage..."
    while true; do
        # Get CPU and memory usage percentages
        cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
        memory_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
        
        # Print the current usage
        echo "CPU Usage: ${cpu_usage}%"
        echo "Memory Usage: ${memory_usage}%"

        # Add your custom alerting logic here
        # For example, send an email if CPU or memory usage exceeds a certain threshold

        sleep $INTERVAL
    done
}

# Main script
monitor_server
