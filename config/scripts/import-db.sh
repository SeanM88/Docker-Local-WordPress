#!/bin/bash

set -u # exit on error & treat unset variables as errors
cd $(dirname "$0") # ensure script commands run from /scripts dir
source "../../.env" # load .env variables

DB_PATH=$(echo $(cd ../database && pwd))
DB_FILE=$(echo "${DB_NAME}.sql")
DB_USER=$(echo "$DB_USER")
DB_PASSWORD=$(echo "$DB_PASSWORD")

# try to import database file if it exists using docker exec command (https://docs.docker.com/engine/reference/commandline/exec/)
if [ -f "$DB_PATH/$DB_FILE" ]; then
  echo "Found ${DB_FILE} file, importing now..."
  docker exec -i "${COMPOSE_PROJECT_NAME}_mysql_1" sh -c "exec mysql -u${DB_USER} -p${DB_PASSWORD} ${DB_NAME}" < $(echo "$DB_PATH/$DB_FILE")
else
  echo "ERROR: Unable to find '${DB_FILE}' file in project's '/config/database' directory!"
  echo "To import a database using this script, place '${DB_FILE}' file in project's '/config/database' directory, then try again."
fi
