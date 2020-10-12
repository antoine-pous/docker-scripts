#!/bin/bash

set -e
set -u

if [ -n "$SCRIPTS_POSTGRES_DATABASES" ]; then
	echo "Multiple database creation requested: $POSTGRES_MULTIPLE_DATABASES"
	for database in $(echo $SCRIPTS_POSTGRES_DATABASES | tr ',' ' '); do
	  echo "  Creating database '$database' with owner '$POSTGRES_USER'"
	  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
	    CREATE DATABASE $database OWNER $POSTGRES_USER;
EOSQL
	done
	echo "Multiple databases created"
fi