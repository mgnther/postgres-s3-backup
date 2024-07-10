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

echo "$(get_date) Postgres backup started of DB $DATABASE from $DATABASE_HOST with port $DATABASE_PORT and user $DATABASE_USER"

aws configure set default.s3.multipart_chunksize 200MB 
PGPASSWORD=$DATABASE_PASSWORD pg_dump -c -U $DATABASE_USER -h $DATABASE_HOST -p $DATABASE_PORT --no-owner --no-privileges -v $DATABASE | aws s3 cp - s3://$AWS_BUCKET/$FILE_PREFIX`date +%d-%m-%Y`.sql

echo "$(get_date) Postgres backup completed successfully!"
