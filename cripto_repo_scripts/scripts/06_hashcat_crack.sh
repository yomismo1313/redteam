#!/bin/bash
# 06_hashcat_crack.sh
# Ataque de fuerza bruta / diccionario con hashcat sobre un hash MD5
# (formato hashing6 del writeup).
#
# Uso:
#   ./06_hashcat_crack.sh <hash> [wordlist]
#
# Si no se especifica wordlist, usa rockyou.txt por defecto.
#
# Ejemplo (del writeup):
#   ./06_hashcat_crack.sh 0192023a7bbd73250516f069df18b500
#   -> resultado: 0192023a7bbd73250516f069df18b500:admin123

set -euo pipefail

HASH="${1:?Uso: $0 <hash_md5> [wordlist]}"
WORDLIST="${2:-/usr/share/wordlists/rockyou.txt}"

echo "$HASH" > /tmp/hash.txt

echo "[*] Lanzando hashcat (modo 0 = MD5) contra ${WORDLIST} ..."
hashcat -m 0 -a 0 /tmp/hash.txt "$WORDLIST"

echo
echo "[*] Mostrando resultado (si se encontro):"
hashcat -m 0 /tmp/hash.txt --show
