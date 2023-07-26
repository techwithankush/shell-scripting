#!/bin/bash

# Get environment variables from the user or environment-specific secrets
DB_HOST="db.example.com"
DB_USER="db_user"
DB_PASSWORD="password123"

# Function to generate the configuration file from the template
function generate_config_file() {
    local template_file="$1"
    local output_file="$2"

    # Replace placeholders with actual values
    sed "s/{{DB_HOST}}/$DB_HOST/g; s/{{DB_USER}}/$DB_USER/g; s/{{DB_PASSWORD}}/$DB_PASSWORD/g" $template_file > $output_file

    echo "Configuration file generated: $output_file"
}

# Main script
echo "Generating configuration for the development environment..."
generate_config_file "config_template.json" "config_dev.json"

echo "Generating configuration for the staging environment..."
generate_config_file "config_template.json" "config_staging.json"

echo "Generating configuration for the production environment..."
generate_config_file "config_template.json" "config_prod.json"
