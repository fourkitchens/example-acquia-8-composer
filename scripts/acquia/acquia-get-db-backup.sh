#!/bin/bash

# ------------------------------------------------------------------------------
# Get the latest "daily" database backup from Acquia.
#
# Required environmental variables should be set via the CircleCI web interface:
#
# - ACQUIA_USER (Cloud API E-mail)
# - ACQUIA_TOKEN (Cloud API Private key)
#
# Required script parameters:
#
# - $1 : realm:mysite (eg. prod:mysite)
# - $2 : environment (eg. prod)
# - $3 : database (eg. mysite)
# ------------------------------------------------------------------------------

SCRIPT_PATH=$(dirname "$0")
ARTIFACTS_PATH=$(cd $SCRIPT_PATH/../../reference && pwd)
SQL_FILENAME=backup.sql.gz

# Make sure artifacts directory is writable.
chmod -R +rw $ARTIFACTS_PATH

# Check if artifacts/$SQL_FILENAME exists.
if [ ! -e $ARTIFACTS_PATH/$SQL_FILENAME ]
then
  # Download the JSON file of available dabatase backups.
  curl -L -u $ACQUIA_USER:$ACQUIA_TOKEN $ACQUIA_ENDPOINT/sites/$1/envs/$2/dbs/$3/backups.json > db_backups.json
  # Move db_backups.json into the artifacts folder.
  if [ -e db_backups.json ]
  then
    mv db_backups.json $ARTIFACTS_PATH/db_backups.json
  fi

  # Validate artifacts/db_backups.json.
  if [ ! -e $ARTIFACTS_PATH/db_backups.json ]
  then
    echo "File $ARTIFACTS_PATH/db_backups.json not found!"
    exit 1
  elif egrep -q "Service Unavailable|Resource not found" $ARTIFACTS_PATH/db_backups.json
  then
    echo "Cannot connect to Acquia Cloud!"
    rm $ARTIFACTS_PATH/db_backups.json
    exit 1
  fi

  # Write the last database backup's id into artifacts/db_backup_id.
  php $SCRIPT_PATH/acquia-get-db-backup-id.php $ARTIFACTS_PATH

  # Exit if PHP code fails.
  if [ $? -eq 1 ];
  then
    exit 1
  fi

  # Download database backup.
  curl -L -u $ACQUIA_USER:$ACQUIA_TOKEN $ACQUIA_ENDPOINT/sites/$1/envs/$2/dbs/$3/backups/$(<$ARTIFACTS_PATH/db_backup_id)/download.json > $SQL_FILENAME
  # Move $SQL_FILENAME into the artifacts folder.
  if [ -e $SQL_FILENAME ]
  then
    mv $SQL_FILENAME $ARTIFACTS_PATH/$SQL_FILENAME
  else
    echo "Failed to download $ARTIFACTS_PATH/$SQL_FILENAME!"
    exit 1
  fi
fi
