ARG PG_VERSION=15.4

# hadolint ignore=DL3006
FROM postgres:${PG_VERSION}

ARG PG_BIGM_VERSION=1.2-20200228

# hadolint ignore=DL3008,DL4006
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gcc \
    make \
    "postgresql-server-dev-$(echo $PG_VERSION | cut -d '.' -f1)" \
    && apt-get clean \
    && update-ca-certificates \
    && rm -rf "/var/lib/apt/lists/*" \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen

RUN curl -L "https://ja.osdn.net/projects/pgbigm/downloads/72448/pg_bigm-${PG_BIGM_VERSION}.tar.gz" -o /tmp/pg_bigm.tar.gz

# hadolint ignore=DL3003
RUN mkdir -p /tmp/pg_bigm \
    && tar -zxf /tmp/pg_bigm.tar.gz -C /tmp/pg_bigm --strip-components=1 \
    && cd /tmp/pg_bigm \
    && make USE_PGXS=1 \
    && make USE_PGXS=1 install \
    && cd .. \
    && rm -rf /tmp/pg_bigm /tmp/pg_bigm.tar.gz

# RUN sudo -u postgres initdb -D "$PGDATA"

# RUN echo shared_preload_libraries = 'pg_bigm' >> "$PGDATA/postgresql.conf"

# ENTRYPOINT ["bash", "-c", "sleep 1000000"]
