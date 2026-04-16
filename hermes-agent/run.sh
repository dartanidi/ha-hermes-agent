#!/bin/bash
set -e

echo "[Info] Starting Hermes Agent App for Home Assistant..."

CONFIG_PATH=/data/options.json

# Read configuration from HA UI
API_SERVER_ENABLED=$(jq --raw-output '.api_server_enabled' $CONFIG_PATH)
API_SERVER_KEY=$(jq --raw-output '.api_server_key' $CONFIG_PATH)

# Persistent storage setup
export HOME=/data
export HERMES_HOME=/data
mkdir -p /data/.hermes

# Generate environment configuration
echo "[Info] Configuring API Server..."
cat <<EOF > /data/.hermes/.env
API_SERVER_ENABLED=${API_SERVER_ENABLED}
API_SERVER_KEY=${API_SERVER_KEY}
EOF

# 1. Start Hermes Gateway in background
echo "[Info] Starting Hermes Gateway in background..."
hermes gateway run &

# 2. Start Web Terminal (Ingress) in foreground
echo "[Info] Starting Web Terminal on port 8099..."
exec ttyd -p 8099 -W bash
