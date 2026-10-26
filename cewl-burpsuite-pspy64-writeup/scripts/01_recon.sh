#!/usr/bin/env bash
#
# 01_recon.sh
# Descubrimiento de host y escaneo de puertos/servicios.
#
# Uso:
#   ./01_recon.sh <interfaz> [subred_opcional]
#
# Ejemplo:
#   ./01_recon.sh eth1
#
set -euo pipefail

IFACE="${1:?Uso: $0 <interfaz> [target_ip]}"
TARGET="${2:-}"

echo "[*] Descubriendo hosts activos en la red local con arp-scan..."
sudo arp-scan --interface="${IFACE}" --localnet

if [[ -z "${TARGET}" ]]; then
  read -rp "[?] Introduce la IP objetivo detectada arriba: " TARGET
fi

echo "[*] Lanzando escaneo de versiones/servicios contra ${TARGET}..."
sudo nmap -sV -Pn -sS -vv "${TARGET}"
