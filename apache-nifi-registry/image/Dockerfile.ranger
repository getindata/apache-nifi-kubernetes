FROM maven:3.6.3-openjdk-8 AS build

ARG NIFI_REGISTRY_VERSION=0.8.0
WORKDIR /tmp
RUN wget https://github.com/apache/nifi-registry/archive/rel/nifi-registry-${NIFI_REGISTRY_VERSION}.zip \
    && unzip nifi-registry-${NIFI_REGISTRY_VERSION}.zip \
    && cd nifi-registry-rel-nifi-registry-${NIFI_REGISTRY_VERSION} \
    && mvn clean install -f nifi-registry-extensions/nifi-registry-ranger

FROM openjdk:8-jre AS registry

LABEL maintainer="albert.lewandowski@getindata.com"
LABEL site="https://nifi.apache.org/registry.html"

ARG NIFI_REGISTRY_BINARY
ARG NIFI_REGISTRY_VERSION=0.8.0
ARG NIFI_VERSION=1.13.2
ARG RANGER_VERSION=2.1.0

ARG UID=1000
ARG GID=1000

ENV NIFI_REGISTRY_BASE_DIR=/opt/nifi-registry
ENV NIFI_REGISTRY_HOME=${NIFI_REGISTRY_BASE_DIR}/nifi-registry-current
ENV NIFI_RANGER_LIB=${NIFI_REGISTRY_HOME}/ext/ranger

WORKDIR ${NIFI_REGISTRY_HOME}

ADD sh/ ${NIFI_REGISTRY_BASE_DIR}/scripts/

COPY $NIFI_REGISTRY_BINARY $NIFI_REGISTRY_BASE_DIR

# Set up Ranger Plugin
COPY --from=build /tmp/nifi-registry-rel-nifi-registry-${NIFI_REGISTRY_VERSION}/nifi-registry-extensions/nifi-registry-ranger/nifi-registry-ranger-assembly/target/nifi-registry-ranger-assembly-${NIFI_REGISTRY_VERSION}-bin.zip /tmp
RUN mkdir -p ${NIFI_RANGER_LIB} \
    && unzip -d ${NIFI_RANGER_LIB} /tmp/nifi-registry-ranger-assembly-${NIFI_REGISTRY_VERSION}-bin.zip \
    && rm /tmp/nifi-registry-ranger-assembly-${NIFI_REGISTRY_VERSION}-bin.zip \
    && chown -R nifi:nifi ${NIFI_RANGER_LIB} \
    && mkdir -p /etc/ranger/nifi-registry/policycache \
    && chown -R nifi:nifi /etc/ranger/nifi-registry/policycache

# Install NiFi Registry
RUN wget http://archive.apache.org/dist/nifi/nifi-registry/nifi-registry-${NIFI_REGISTRY_VERSION}/nifi-registry-${NIFI_REGISTRY_VERSION}-bin.zip \
    && mv nifi-registry-${NIFI_REGISTRY_VERSION}-bin.zip ${NIFI_REGISTRY_BASE_DIR}/nifi-registry-${NIFI_REGISTRY_VERSION}-bin.zip \
    && unzip ${NIFI_REGISTRY_BASE_DIR}/nifi-registry-${NIFI_REGISTRY_VERSION}-bin.zip -d ${NIFI_REGISTRY_BASE_DIR} \
    && rm ${NIFI_REGISTRY_BASE_DIR}/nifi-registry-${NIFI_REGISTRY_VERSION}-bin.zip \
    && mv ${NIFI_REGISTRY_BASE_DIR}/nifi-registry-${NIFI_REGISTRY_VERSION} ${NIFI_REGISTRY_HOME} \
    && ln -s ${NIFI_REGISTRY_HOME} ${NIFI_REGISTRY_BASE_DIR}/nifi-registry-${NIFI_REGISTRY_VERSION}

# Setup NiFi user and create necessary directories
RUN groupadd -g ${GID} nifi || groupmod -n nifi `getent group ${GID} | cut -d: -f1` \
    && useradd --shell /bin/bash -u ${UID} -g ${GID} -m nifi \
    && chown -R nifi:nifi ${NIFI_REGISTRY_BASE_DIR} \
    && apt-get update \
    && apt-get install -y jq xmlstarlet procps git libc6 zip \
    && ln -s /lib/x86_64-linux-gnu/libc.so.6 /lib/libc.so.6 \
    && ln -s /lib/x86_64-linux-gnu/libc.so.6 /lib/x86_64-linux-gnu/libc.so

# Install Postgres JDBC plugin if you use Postgres as database in Registry
RUN wget https://jdbc.postgresql.org/download/postgresql-42.2.18.jar -P /opt/nifi-registry/current/lib

USER nifi

# Web HTTP(S) ports
EXPOSE 18080 18443

ENTRYPOINT ["../scripts/start.sh"]
