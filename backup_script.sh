#!/bin/bash

# Variables
DB_NAME="bhogi"  # Replace with your actual database name
BACKUP_DIR="/root/mango"  # Replace with the directory where you want to store the backup
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/$DB_NAME_$TIMESTAMP.tar.gz"
S3_BUCKET="pandemkodi"  # Replace with your actual S3 bucket name
#S3_PATH="backups/$DB_NAME/$TIMESTAMP.tar.gz"

# Step 1: Backup MongoDB using mongodump
mongodump --db $DB_NAME --archive=$BACKUP_FILE --gzip

# Step 2: Upload to AWS S3
aws s3 cp $BACKUP_FILE s3://$S3_BUCKET
