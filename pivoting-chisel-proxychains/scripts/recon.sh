#!/bin/bash
# 01_recon.sh
# Descubrimiento inicial de red y escaneo de servicios.
#
# Uso:
#   ./01_recon.sh <interfaz> <ip_objetivo> <directorio_salida>
#
# Ejemplo:
#   ./01_recon.sh eth1 10.0.2.8 ./pivoting/vm1

set -euo pipefail

IFACE="${1:?Uso: $0 <interfaz> <ip_objetivo> <directorio_salida>}"
TARGET="${2:?Falta la IP objetivo}"
OUTDIR="${3:?Falta el directorio de salida}"

mkdir -p "$OUTDIR"

echo "[*] Escaneo ARP en la interfaz $IFACE..."
sudo arp-scan --interface="$IFACE" --localnet | tee "$OUTDIR/arp-scan.txt"

echo
echo "[*] IP propia:"
ip a

echo
echo "[*] Escaneo nmap contra $TARGET..."
sudo nmap -sV -Pn -sS -O -n "$TARGET" -o "$OUTDIR/nmap.txt"

echo
echo "[*] Resultados guardados en $OUTDIR/"
