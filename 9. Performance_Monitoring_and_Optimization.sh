#!/bin/bash

# Function to collect system performance metrics
collect_metrics() {
    # Get CPU utilization percentage
    CPU_UTILIZATION=$(top -bn 1 | grep '%Cpu' | awk '{print $2}' | cut -d '.' -f 1)

    # Get Memory utilization percentage
    MEMORY_UTILIZATION=$(free | grep Mem | awk '{print $3/$2 * 100}' | cut -d '.' -f 1)

    # Get Disk usage percentage of the root filesystem
    DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | cut -d '%' -f 1)

    # Get the number of TCP connections
    TCP_CONNECTIONS=$(netstat -nat | grep ESTABLISHED | wc -l)

    # Output metrics
    echo "CPU Utilization: $CPU_UTILIZATION%"
    echo "Memory Utilization: $MEMORY_UTILIZATION%"
    echo "Disk Usage: $DISK_USAGE%"
    echo "TCP Connections: $TCP_CONNECTIONS"
}

# Function to optimize resource usage
optimize_resources() {
    # Get the total memory available in MB
    TOTAL_MEMORY=$(free -m | awk '/^Mem:/{print $2}')

    # Calculate the threshold for memory usage
    MEMORY_THRESHOLD=$((TOTAL_MEMORY / 2))

    # If memory usage exceeds the threshold, perform optimizations
    if [ $MEMORY_UTILIZATION -ge $MEMORY_THRESHOLD ]; then
        # Identify memory-hungry processes and kill the top 3 offenders
        echo "Memory usage is high. Identifying and killing memory-hungry processes..."
        ps aux --sort=-%mem | awk 'NR>1 {print $2}' | head -n 3 | xargs kill -9
        echo "Memory optimization complete."
    else
        echo "Memory usage is within acceptable limits. No optimizations needed."
    fi
}

# Call the functions to collect metrics and optimize resources
collect_metrics
optimize_resources
