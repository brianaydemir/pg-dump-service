pg-dump-service
===============


Environment variables
---------------------

These variables must be defined, except where otherwise noted.

S3 connection parameters:

- ``S3_HOST``
- ``S3_ACCESS_KEY``
- ``S3_SECRET_KEY``

S3 storage location:

- ``BUCKET_NAME``
- ``OBJECT_PREFIX``: Should not end with a ``/``.

Postgres connection parameters:

- ``PG_HOST``
- ``PG_PORT``
- ``PG_USER``
- ``PG_PASSWORD``
- ``PG_DATABASE``

Other configuration:

- ``PG_DUMP_OPTIONS``:
  Optional.
  May contain additional command-line flags to pass to ``pg_dump``.
