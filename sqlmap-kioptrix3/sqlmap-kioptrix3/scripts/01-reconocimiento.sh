#!/bin/bash
# ==============================================================
# 01 - Reconocimiento: arp-scan + nmap
# --------------------------------------------------------------
# Descubre hosts activos en la red local y realiza un escaneo
# profundo de puertos y servicios sobre el objetivo identificado.
#
# Ajusta INTERFACE y TARGET_IP antes de ejecutar.
# ==============================================================

set -e

INTERFACE="eth1"
TARGET_IP="10.0.2.26"
OUTPUT_DIR="/home/kali/reto_final/vm1"

echo "[*] Descubriendo hosts en la red local..."
sudo arp-scan --interface="${INTERFACE}" --localnet

echo ""
echo "[*] Escaneo profundo con nmap sobre ${TARGET_IP}..."
mkdir -p "${OUTPUT_DIR}"
sudo nmap -sV -Pn -sS -O -n "${TARGET_IP}" -o "${OUTPUT_DIR}/nmap.txt"

cat "${OUTPUT_DIR}/nmap.txt"

# Parámetros nmap utilizados:
#   -sV   Detecta versión de servicios
#   -Pn   Sin enviar ping previo (evita bloqueos)
#   -sS   Escaneo SYN sigiloso (sin completar el handshake)
#   -O    Detecta el sistema operativo
#   -n    Sin resolución DNS
#   -o    Guarda la salida en fichero de texto
