#!/bin/bash
# 04_add_proxychain.sh
# Añade una nueva entrada socks5 127.0.0.1 <puerto> al final del
# bloque [ProxyList] de /etc/proxychains4.conf, evitando duplicados.
#
# Uso (requiere sudo):
#   sudo ./04_add_proxychain.sh <puerto>
#
# Ejemplo:
#   sudo ./04_add_proxychain.sh 1080
#   sudo ./04_add_proxychain.sh 1081
#   sudo ./04_add_proxychain.sh 1082

set -euo pipefail

PORT="${1:?Uso: $0 <puerto>}"
CONF="/etc/proxychains4.conf"
LINE="socks5  127.0.0.1  ${PORT}"

if [ ! -f "$CONF" ]; then
    echo "[!] No se encuentra $CONF"
    exit 1
fi

if grep -q "127.0.0.1[[:space:]]*${PORT}\b" "$CONF"; then
    echo "[*] El puerto ${PORT} ya esta configurado en ${CONF}"
    exit 0
fi

echo "[*] Añadiendo '${LINE}' a ${CONF} ..."
echo "$LINE" >> "$CONF"

echo "[*] Hecho. Entradas socks5 actuales:"
grep -i "^socks" "$CONF"
