#!/bin/bash

# Define variables
BACKUP_DIR="/path/to/your/backup/directory"
APP_DIR="/path/to/your/application"
DB_USER="your_database_user"
DB_PASS="your_database_password"
DB_NAME="your_database_name"
DATE=$(date +%Y%m%d_%H%M%S)

# Create a backup directory if it doesn't exist
mkdir -p $BACKUP_DIR

# Backup the database
mysqldump -u $DB_USER -p$DB_PASS $DB_NAME > $BACKUP_DIR/db_backup_$DATE.sql

# Backup the application files
tar -czvf $BACKUP_DIR/app_backup_$DATE.tar.gz $APP_DIR

echo "Backup completed successfully. Database and application files are stored in $BACKUP_DIR."

________________________________________________________________________________________________

#!/bin/bash

# Define variables
BACKUP_DIR="/path/to/your/backup/directory"

# Prompt the user to enter the timestamp of the backup to restore
echo "Available backups:"
ls -l $BACKUP_DIR | grep '^d'
echo "Enter the timestamp of the backup you want to restore (format: YYYYMMDD_HHMMSS):"
read TIMESTAMP

# Restore the database
mysql -u your_database_user -p your_database_name < $BACKUP_DIR/db_backup_$TIMESTAMP.sql

# Restore the application files
tar -xzvf $BACKUP_DIR/app_backup_$TIMESTAMP.tar.gz -C /

echo "Data restoration completed successfully."
