#!/bin/bash

set -u
set -e

cd /docker-entrypoint-initdb.d
if [ -n "$SCRIPTS_POSTGRES_DATABASES" ] && [ -n "$POSTGRES_USER" ]; then
  echo "Checking database dump to import..."
  for path in `find ./dumps -type f -name "*.dump" 2>/dev/null`; do
    filename=${path##*/}
    if [ -f "./$path" ]; then
      echo "Dump file '$filename' detected!"
      DATABASES=$(echo $SCRIPTS_POSTGRES_DATABASES | tr ',' ' ')
      dbname=${filename%.*}
      if [[ " ${DATABASES[@]} " =~ " ${dbname} " ]]; then
        echo "Importing '$filename' into '$dbname' database..."
        pg_restore --verbose --clean --no-acl --no-owner -U $POSTGRES_USER --dbname $dbname $path;
      else
        echo "Dump file '$filename' ignored! No database named '$dbname' were detected in 'SCRIPTS_POSTGRES_DATABASES' docker env!"
      fi
    fi
  done
fi
