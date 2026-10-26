#!/bin/bash
# 06_chisel_client.sh
# Conecta como cliente Chisel a un servidor en modo --reverse,
# exponiendo un proxy SOCKS o un puerto remoto especifico en el
# servidor (pivote anterior).
#
# Uso:
#   ./06_chisel_client.sh <ruta_chisel> <ip_servidor> <puerto_servidor> [puerto_remoto]
#
# Ejemplos:
#   # Proxy SOCKS generico (R:socks -> expone 127.0.0.1:1080 en el servidor)
#   ./06_chisel_client.sh ./chisel 10.0.2.14 9000
#
#   # Proxy SOCKS en un puerto remoto especifico (R:<puerto>:socks)
#   ./06_chisel_client.sh ./chisel32 10.0.3.4 9001 1082

set -euo pipefail

CHISEL_BIN="${1:?Uso: $0 <ruta_chisel> <ip_servidor> <puerto_servidor> [puerto_remoto]}"
SERVER_IP="${2:?Falta la IP del servidor chisel}"
SERVER_PORT="${3:?Falta el puerto del servidor chisel}"
REMOTE_PORT="${4:-}"

if [ ! -x "$CHISEL_BIN" ]; then
    chmod +x "$CHISEL_BIN" 2>/dev/null || true
fi

if [ -n "$REMOTE_PORT" ]; then
    REMOTE_SPEC="R:${REMOTE_PORT}:socks"
else
    REMOTE_SPEC="R:socks"
fi

echo "[*] Conectando a ${SERVER_IP}:${SERVER_PORT} exponiendo ${REMOTE_SPEC} ..."
"$CHISEL_BIN" client "${SERVER_IP}:${SERVER_PORT}" "$REMOTE_SPEC"
