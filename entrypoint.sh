#!/bin/bash
set -e
set -o pipefail

# Date function
get_date () {
    date +[%Y-%m-%d\ %H:%M:%S]
}

# Script
: ${GPG_KEYSERVER:='keyserver.ubuntu.com'}
: ${GPG_KEYID:=''}
: ${COMPRESS:='pigz'}
: ${MAINTENANCE_DB:='postgres'}
START_DATE=`date +%Y-%m-%d_%H-%M-%S`

if [ -z "$GPG_KEYID" ]
then
    echo "$(get_date) !WARNING! It's strongly recommended to encrypt your backups."
fi

echo "$(get_date) Postgres backup started"

PGPASSWORD=$DATABASE_PASSWORD pg_dumpall -c -U $DATABASE_USER -h $DATABASE_HOST | aws s3 cp - s3://speechmind-db-backup/dump_prod_`date +%d-%m-%Y`.sql

echo "$(get_date) Postgres backup completed successfully"