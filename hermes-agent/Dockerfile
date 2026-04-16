ARG BUILD_FROM=nousresearch/hermes-agent:latest
FROM ${BUILD_FROM}

# Switch to root to install system dependencies for the App
USER root
RUN apt-get update && \
    apt-get install -y jq ttyd tmux && \
    rm -rf /var/lib/apt/lists/*

# Copy local script
COPY run.sh /run.sh
RUN chmod a+x /run.sh

# Reset entrypoint and set start command
ENTRYPOINT []
CMD [ "/run.sh" ]
