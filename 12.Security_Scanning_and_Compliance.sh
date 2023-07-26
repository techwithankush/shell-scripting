#!/bin/bash

# Variables
WEB_APP_URL="http://example.com"
EXPECTED_STATUS_CODE="200"
SECURITY_HEADERS=("X-XSS-Protection" "X-Content-Type-Options" "Content-Security-Policy")

# Function to perform a basic security scan on the web application
function perform_security_scan() {
    # Check HTTP response status
    status_code=$(curl -s -o /dev/null -w "%{http_code}" $WEB_APP_URL)

    if [ "$status_code" -eq "$EXPECTED_STATUS_CODE" ]; then
        echo "Web application is up and running (HTTP 200 OK)."
    else
        echo "Web application is not responding as expected (HTTP $status_code)."
    fi

    # Check for open ports using nmap
    echo "Running port scan on the web server..."
    nmap_output=$(nmap $WEB_APP_URL)
    echo "$nmap_output"
}

# Function to check compliance with security headers
function check_security_headers() {
    echo "Checking security headers in the HTTP response..."
    
    for header in "${SECURITY_HEADERS[@]}"; do
        header_value=$(curl -s -I $WEB_APP_URL | grep -i $header)
        if [ -z "$header_value" ]; then
            echo "Security header '$header' not found in the HTTP response."
        else
            echo "Security header '$header' is present: $header_value"
        fi
    done
}

# Main script
echo "Starting security scan and compliance checks for the web application: $WEB_APP_URL"

# Perform security scan
perform_security_scan

# Check compliance with security headers
check_security_headers

echo "Security scan and compliance checks completed."
