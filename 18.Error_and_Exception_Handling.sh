#!/bin/bash

# Function to send email notification
function send_notification() {
    local recipient="$1"
    local subject="$2"
    local body="$3"

    echo "$body" | mail -s "$subject" "$recipient"
}

# Function to perform a critical operation
function perform_critical_operation() {
    # Replace this with your critical operation code
    # For this example, we simulate an error by dividing by zero
    result=$(echo "1 / 0" | bc)
    echo "Result: $result"
}

# Main script
echo "Starting the critical operation..."

# Redirecting error output to a temporary file
temp_file=$(mktemp)
if ! perform_critical_operation 2> "$temp_file"; then
    # Error occurred, send notification
    error_message="Critical operation failed: $(cat "$temp_file")"
    send_notification "admin@example.com" "Error in Critical Operation" "$error_message"
    rm "$temp_file"
    exit 1
fi

echo "Critical operation completed successfully."
