#!/bin/bash
# 07_host_discovery.sh
# Descubrimiento de hosts vivos en una subred /24 mediante ping.
# Util para ejecutar DIRECTAMENTE en la maquina pivote comprometida
# (sin proxychains), cuando nmap/arp-scan no son fiables.
#
# Uso:
#   ./07_host_discovery.sh <prefijo_red>
#
# Ejemplo:
#   ./07_host_discovery.sh 10.0.3
#   -> hace ping a 10.0.3.1 .. 10.0.3.254

set -euo pipefail

PREFIX="${1:?Uso: $0 <prefijo_red, ej: 10.0.3>}"

echo "[*] Descubriendo hosts vivos en ${PREFIX}.0/24 ..."

for i in $(seq 1 254); do
    ping -c1 -W1 "${PREFIX}.${i}" >/dev/null 2>&1 && echo "Host vivo: ${PREFIX}.${i}"
done

echo "[*] Descubrimiento finalizado."
