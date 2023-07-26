#!/bin/bash

# Database connection details
DB_HOST="localhost"
DB_USER="db_user"
DB_PASSWORD="db_password"
DB_NAME="my_database"

# Backup directory
BACKUP_DIR="/path/to/backups"

# Function to perform a database backup
function backup_database() {
    TIMESTAMP=$(date +%Y%m%d%H%M%S)
    BACKUP_FILE="${BACKUP_DIR}/backup_${TIMESTAMP}.sql"
    
    mysqldump -h ${DB_HOST} -u ${DB_USER} -p${DB_PASSWORD} ${DB_NAME} > ${BACKUP_FILE}
    
    echo "Database backup created: ${BACKUP_FILE}"
}

# Function to restore the database from a backup file
function restore_database() {
    BACKUP_FILE=$1

    if [ ! -f $BACKUP_FILE ]; then
        echo "Backup file not found: $BACKUP_FILE"
        exit 1
    fi

    mysql -h ${DB_HOST} -u ${DB_USER} -p${DB_PASSWORD} ${DB_NAME} < ${BACKUP_FILE}

    echo "Database restored from: ${BACKUP_FILE}"
}

# Function to perform schema migrations
function run_migrations() {
    # Put your schema migration commands here
    # Example: mysql -h ${DB_HOST} -u ${DB_USER} -p${DB_PASSWORD} ${DB_NAME} < migration_script.sql
    echo "Running database schema migrations..."
    echo "Migrations completed."
}

# Main script
case "$1" in
    backup)
        backup_database
        ;;
    restore)
        if [ -z "$2" ]; then
            echo "Usage: $0 restore <backup_file>"
            exit 1
        fi
        restore_database "$2"
        ;;
    migrate)
        run_migrations
        ;;
    *)
        echo "Usage: $0 {backup|restore|migrate}"
        exit 1
esac
