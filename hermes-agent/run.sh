#!/bin/bash
set -e

echo "[Info] Starting Hermes Agent App for Home Assistant..."

CONFIG_PATH=/data/options.json
API_SERVER_ENABLED=$(jq --raw-output '.api_server_enabled' $CONFIG_PATH)
API_SERVER_KEY=$(jq --raw-output '.api_server_key' $CONFIG_PATH)

# 1. Salviamo i percorsi originali nel PATH prima di fare modifiche
export PATH=$PATH:/root/.local/bin:/usr/local/bin:/opt/hermes/bin

# 2. Ora possiamo cambiare in modo sicuro la Home per la persistenza dei dati
export HOME=/data
export HERMES_HOME=/data
mkdir -p /data/.hermes

echo "[Info] Configuring API Server..."
cat <<EOF > /data/.hermes/.env
API_SERVER_ENABLED=${API_SERVER_ENABLED}
API_SERVER_KEY=${API_SERVER_KEY}
EOF

# 3. Caccia all'eseguibile: se hermes non è nel PATH, lo cerchiamo e lo colleghiamo
if ! command -v hermes &> /dev/null; then
    echo "[Info] Cerco l'eseguibile hermes nel sistema..."
    HERMES_BIN=$(find / -name hermes -type f -executable 2>/dev/null | grep bin/hermes | head -n 1)
    if [ -n "$HERMES_BIN" ]; then
        echo "[Info] Eseguibile trovato in: $HERMES_BIN"
        ln -s "$HERMES_BIN" /usr/local/bin/hermes
    else
        echo "[Errore] Impossibile trovare l'eseguibile di Hermes. Il container potrebbe essere strutturato diversamente."
    fi
fi

# 4. Avvio di Hermes Gateway in background
echo "[Info] Starting Hermes Gateway in background..."
hermes gateway run &

# 5. Avvio del Terminale Web (Ingress) in foreground
echo "[Info] Starting Web Terminal on port 8099..."
exec ttyd -p 8099 -W bash
