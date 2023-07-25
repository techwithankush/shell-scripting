#!/bin/bash

# Function to configure environment-specific settings
configure_environment() {
    ENVIRONMENT=$1
    case "$ENVIRONMENT" in
        "development")
            API_BASE_URL="http://dev-api.example.com"
            LOG_LEVEL="debug"
            ;;
        "staging")
            API_BASE_URL="http://staging-api.example.com"
            LOG_LEVEL="info"
            ;;
        "production")
            API_BASE_URL="http://api.example.com"
            LOG_LEVEL="error"
            ;;
        *)
            echo "Invalid environment. Usage: $0 <development|staging|production>"
            exit 1
            ;;
    esac

    # Create or update environment-specific configuration file
    cat > config.js <<EOF
module.exports = {
    apiBaseUrl: "$API_BASE_URL",
    logLevel: "$LOG_LEVEL"
};
EOF

    echo "Environment '$ENVIRONMENT' configuration completed."
}

# Check if an argument (environment name) is provided
if [ $# -eq 0 ]; then
    echo "Please provide the environment name. Usage: $0 <development|staging|production>"
    exit 1
fi

# Navigate to the application directory
cd /path/to/your/application

# Install application dependencies
npm install

# Run the function to configure the environment
configure_environment $1
