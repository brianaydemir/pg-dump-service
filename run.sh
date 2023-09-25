#!/bin/bash

set -eu
set -o pipefail

THIS_FILE="$(basename -- "$0")"

current_time() { date -u +"%Y-%m-%dT%H%M%S"; }
info() { printf '%s\n' "[$(current_time)] INFO ${THIS_FILE} $*"; }

info "Starting"


############################################################################
# Configure clients.


cat <<EOF >~/.mc/config.json
{
  "version": "10",
  "aliases": {
    "s3": {
      "url": "https://$S3_HOST",
      "accessKey": "$S3_ACCESS_KEY",
      "secretKey": "$S3_SECRET_KEY",
      "api": "s3v4",
      "path": "auto"
    }
  }
}
EOF
chmod u=rw,go= ~/.mc/config.json

cat <<EOF >~/.pgpass
${PG_HOST}:${PG_PORT}:${PG_DATABASE}:${PG_USER}:${PG_PASSWORD}
EOF
chmod u=rw,go= ~/.pgpass


############################################################################
# Create and upload a new database dump.


NOW="$(current_time)"
OBJECT_NAME="${BUCKET_NAME}/${OBJECT_PREFIX}/${PG_DATABASE}-${NOW}"

info "Running 'pg_dump' and storing into '${OBJECT_NAME}'"

# The lack of quotes around PG_DUMP_OPTIONS is intentional.
# shellcheck disable=SC2086
pg_dump -h "${PG_HOST}" -p "${PG_PORT}" -U "${PG_USER}" -Fc ${PG_DUMP_OPTIONS:-} "${PG_DATABASE}" \
  | mc pipe "s3/${OBJECT_NAME}.pg_dump"

printf '%s\n' "$(current_time)" \
  | mc pipe "s3/${OBJECT_NAME}.finished"


############################################################################
# Final cleanup and bookkeeping.


info "Removing old backups"

mc rm --force --recursive --older-than "${TIME_TO_KEEP}" "s3/${BUCKET_NAME}/${OBJECT_PREFIX}"

info "Finished"
