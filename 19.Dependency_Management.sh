#!/bin/bash

# Function to install Python dependencies
function install_python_dependencies() {
    if [ -f "requirements.txt" ]; then
        echo "Installing Python dependencies from requirements.txt..."
        pip install -r requirements.txt
    else
        echo "requirements.txt not found. Skipping Python dependency installation."
    fi
}

# Main script
echo "Starting application dependency installation..."

# Install Python dependencies
install_python_dependencies

echo "Application dependency installation completed."
