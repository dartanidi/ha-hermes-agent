ARG BUILD_FROM=nousresearch/hermes-agent:latest
FROM ${BUILD_FROM}

# Passiamo a root per installare le dipendenze
USER root

# Installiamo jq, tmux, wget e scarichiamo ttyd manualmente in base all'architettura
RUN apt-get update && \
    apt-get install -y jq tmux wget curl && \
    ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ] || [ "$ARCH" = "amd64" ]; then \
        wget -O /usr/local/bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64; \
    elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then \
        wget -O /usr/local/bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.aarch64; \
    fi && \
    chmod +x /usr/local/bin/ttyd && \
    rm -rf /var/lib/apt/lists/*

# Copiamo lo script di avvio
COPY run.sh /run.sh
RUN chmod a+x /run.sh

# Sovrascriviamo l'entrypoint
ENTRYPOINT []
CMD [ "/run.sh" ]
