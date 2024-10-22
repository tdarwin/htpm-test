FROM golang:bookworm

RUN apt update && apt install -y wget curl systemctl make sudo

ENV USER=htpm

ENV UID=10001

ENV GID=10001

RUN groupadd -g $GID $USER

RUN useradd -m -u $UID -g $GID $USER

RUN wget https://honeycomb-builds.s3.amazonaws.com/honeycombio/honeycomb-telemetry-pipeline/1-77-1/honeycomb-telemetry-pipeline-ee-1-77-1_linux_arm64.deb

RUN apt install -y ./honeycomb-telemetry-pipeline-ee-1-77-1_linux_arm64.deb

RUN mkdir /data

RUN chown -R htpm:htpm /data

RUN chmod -R 777 /data

ENV BINDPLANE_CONFIG_HOME=/data

ENV BINDPLANE_LOGGING_OUTPUT=stdout

ENV BINDPLANE_TRANSFORM_AGENT_ENABLE_REMOTE=true

ENV BINDPLANE_PROMETHEUS_ENABLE_REMOTE=true

ENV BINDPLANE_HOST=0.0.0.0

ENV BINDPLANE_PORT=3001

EXPOSE 3001:3001

USER htpm

ENTRYPOINT ["/usr/local/bin/bindplane", "serve"]