#!/bin/bash

# Variables
DB_NAME="bhogi"  # Your DB name
BACKUP_FILE="/root/lemon/restore-backup.tar.gz"  # Location to save the downloaded backup
S3_BUCKET="pandemkodi"  # Your S3 bucket name

# Step 1: Get the latest backup file from S3
echo "Fetching the latest backup file from S3..."
LATEST_BACKUP=$(aws s3 ls s3://$S3_BUCKET/ --recursive | sort | tail -n 1 | awk '{print $4}')

if [ -z "$LATEST_BACKUP" ]; then
  echo "Error: No backup files found in the S3 bucket!"
  exit 1
fi

echo "Latest backup file: $LATEST_BACKUP"

# Step 2: Download the latest backup file from S3
echo "Downloading the latest backup from S3..."
aws s3 cp s3://$S3_BUCKET/$LATEST_BACKUP $BACKUP_FILE

# Verify if the file was downloaded
if [ ! -f "$BACKUP_FILE" ]; then
  echo "Error: Backup file $BACKUP_FILE not found!"
  exit 1
fi

# Step 3: Restore the MongoDB database
echo "Restoring the database..."
mongorestore --nsInclude=$DB_NAME.* --archive=$BACKUP_FILE --gzip

echo "Database restoration completed."
