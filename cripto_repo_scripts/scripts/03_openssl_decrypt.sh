#!/bin/bash
# 03_openssl_decrypt.sh
# Comandos de referencia para descifrar ficheros cifrados con OpenSSL
# en formato "Salted__" (salida de `openssl enc`).
#
# Como identificar el algoritmo:
#   - `cat fichero` mostrara "Salted__" al principio (datos binarios).
#   - El fichero "info.txt" del reto suele dar pistas de la
#     contraseña/algoritmo (lista de candidatos).
#
# Uso:
#   ./03_openssl_decrypt.sh <des3|aes256> <fichero_cifrado> <fichero_salida> <password>
#
# Ejemplos extraidos del writeup:
#   ./03_openssl_decrypt.sh des3   contraseña.txt.des3 contraseña_descifrada.txt Symmetric
#   ./03_openssl_decrypt.sh aes256 contraseña.txt.aes2 contraseña_descifrada.txt AES256Symmetric

set -euo pipefail

MODE="${1:?Uso: $0 <des3|aes256> <fichero_cifrado> <fichero_salida> <password>}"
INFILE="${2:?Falta el fichero cifrado}"
OUTFILE="${3:?Falta el fichero de salida}"
PASS="${4:?Falta la contraseña}"

case "$MODE" in
  des3)
    echo "[*] Descifrando ${INFILE} con 3DES (des3, pbkdf2)..."
    openssl enc -d -des3 -pbkdf2 -in "$INFILE" -out "$OUTFILE" -k "$PASS"
    ;;
  aes256)
    echo "[*] Descifrando ${INFILE} con AES-256-CBC (pbkdf2)..."
    openssl enc -d -aes-256-cbc -pbkdf2 -in "$INFILE" -out "$OUTFILE" -k "$PASS"
    ;;
  *)
    echo "Modo desconocido: $MODE (usa 'des3' o 'aes256')"
    exit 1
    ;;
esac

echo "[*] Resultado guardado en ${OUTFILE}:"
cat "$OUTFILE"
