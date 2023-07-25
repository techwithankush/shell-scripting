#!/bin/bash

# Define the log file path
LOG_FILE="/path/to/your/log/file/app.log"

# Function to send an alert (you can customize this function based on your alerting mechanism)
send_alert() {
    MESSAGE="$1"
    echo "ALERT: $MESSAGE"
    # Replace the following line with your actual alerting mechanism (e.g., sending an email, triggering a webhook, etc.).
    # For demonstration purposes, we'll simply log the alert to a file named alerts.log.
    echo "ALERT: $MESSAGE" >> alerts.log
}

# Analyze the log file
analyze_log() {
    # Get the number of occurrences of the error message in the log file
    ERROR_COUNT=$(grep -c "ERROR" "$LOG_FILE")

    # Get the latest occurrence of the error message
    LATEST_ERROR=$(grep "ERROR" "$LOG_FILE" | tail -n 1)

    # Check if there are any errors
    if [ "$ERROR_COUNT" -gt 0 ]; then
        send_alert "Error found! Total errors: $ERROR_COUNT. Latest error: $LATEST_ERROR"
    else
        echo "No errors found in the log file."
    fi
}

# Run the log analysis function
analyze_log
