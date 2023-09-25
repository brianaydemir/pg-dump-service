FROM postgres:15.4

# Reference: https://github.com/hadolint/hadolint/wiki/DL4006

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install MinIO Client and our custom dump script.

RUN apt-get update -y \
    && apt-get install -y curl \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    #
    && curl -o /usr/local/bin/mc https://dl.min.io/client/mc/release/linux-amd64/mc \
    && chmod u=rwx,go=rx /usr/local/bin/mc \
    #
    && mkdir ~/.mc \
    && chmod u=rwx,go= ~/.mc

COPY run.sh /run.sh
RUN chmod u=rwx,go= /run.sh

# Don't start Postgres.

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["/run.sh"]
