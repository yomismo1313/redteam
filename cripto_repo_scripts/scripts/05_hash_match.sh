#!/bin/bash
# 05_hash_match.sh
# Identifica el tipo de hash con hash-identifier y busca, entre una
# lista de ficheros, cual produce ese hash (md5/sha1/sha256/sha512).
#
# Uso:
#   ./05_hash_match.sh <hash> <algoritmo> <directorio_ficheros>
#
# <algoritmo>: md5sum | sha1sum | sha256sum | sha512sum
#
# Ejemplos extraidos del writeup:
#   ./05_hash_match.sh 9f75f653a20dba0796f5011dddc34aaa md5sum    Creds/
#   ./05_hash_match.sh 26ed6139d311e851d4efa906bfc78e90f970cedd sha1sum   Creds/
#   ./05_hash_match.sh c5f8d03cab180bffb6268f096ebd44840d5d2f5481a75ad588ca02000f572e7c sha256sum Creds/
#   ./05_hash_match.sh 8a2f1de3b96eac2e0687ab9980d450b147aa3cb46ac891c724abaf757495518211ac71b16f59b92e7704ab1f6553e6f9609a977f723abca0f29b10089fe5db44 sha512sum Creds/

set -euo pipefail

TARGET_HASH="${1:?Uso: $0 <hash> <md5sum|sha1sum|sha256sum|sha512sum> <directorio>}"
ALGO="${2:?Falta el algoritmo (md5sum|sha1sum|sha256sum|sha512sum)}"
DIR="${3:?Falta el directorio con los ficheros candidatos}"

echo "[*] Identificando tipo de hash..."
hash-identifier "$TARGET_HASH" || true

echo
echo "[*] Calculando ${ALGO} de los ficheros en ${DIR} ..."
"$ALGO" "${DIR}"/* | tee /tmp/hash_match_output.txt

echo
echo "[*] Buscando coincidencia con ${TARGET_HASH} ..."
MATCH=$(grep -i "^${TARGET_HASH}" /tmp/hash_match_output.txt || true)

if [ -n "$MATCH" ]; then
    echo "[+] Coincidencia encontrada:"
    echo "$MATCH"
    FILE=$(echo "$MATCH" | awk '{print $2}')
    echo
    echo "[*] Contenido de ${FILE}:"
    cat "$FILE"
else
    echo "[!] No se encontro ninguna coincidencia."
fi
