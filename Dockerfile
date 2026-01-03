FROM ubuntu:latest

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chown -R ${USER}:${USER} /usr/local/bin/entrypoint.sh && \
    chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
