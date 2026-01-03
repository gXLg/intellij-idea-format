FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y bash git wget openjdk-21-jre && \
    apt-get clean

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chown -R ${USER}:${USER} /usr/local/bin/entrypoint.sh && \
    chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
