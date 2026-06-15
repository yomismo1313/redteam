#!/bin/bash
# 04_rsa_hybrid_decrypt.sh
# Comandos de referencia para descifrar un esquema hibrido RSA + AES
# (claves "ephemereal_key.enc" + datos cifrados con AES usando esa
# clave como contraseña).
#
# Flujo (segun el writeup, pkencrypt1 -> pkencrypt3):
#
# 1) pkencrypt1: la clave simetrica esta cifrada directamente con la
#    clave RSA privada (RSA-OAEP):
#
#      openssl pkeyutl -decrypt \
#        -inkey keys/privada.pem \
#        -in contraseña.txt.enc \
#        -out contraseña_descifrada.txt
#
#    -> revela usuario/contraseña de pkencrypt2
#
# 2) pkencrypt2: cifrado hibrido AES + RSA.
#    a) Descifrar la clave AES efimera con la clave RSA privada:
#
#      openssl pkeyutl -decrypt \
#        -inkey keys/privada.pem \
#        -in ephemereal_key.enc \
#        -out ephemereal_key_descifrada.txt
#
#    b) Usar esa clave (como "pass:" o "-pass file:") para descifrar
#       el fichero AES:
#
#      openssl enc -aes-256-cbc -pbkdf2 -d \
#        -pass file:ephemereal_key_descifrada.txt \
#        -in contraseña.txt.aes2 \
#        -out contraseña.txt.aes2_descifrada.txt
#
#    -> revela usuario/contraseña de pkencrypt3
#
# Uso interactivo (ejecuta los pasos a mano sustituyendo rutas):

set -euo pipefail

STEP="${1:?Uso: $0 <step1|step2a|step2b> [argumentos...]}"

case "$STEP" in
  step1)
    # ./04_rsa_hybrid_decrypt.sh step1 keys/privada.pem contraseña.txt.enc contraseña_descifrada.txt
    PRIVKEY="${2:?Falta la clave privada}"
    INFILE="${3:?Falta el fichero cifrado}"
    OUTFILE="${4:?Falta el fichero de salida}"

    echo "[*] Descifrando ${INFILE} con RSA (clave privada ${PRIVKEY})..."
    openssl pkeyutl -decrypt -inkey "$PRIVKEY" -in "$INFILE" -out "$OUTFILE"
    cat "$OUTFILE"
    ;;

  step2a)
    # ./04_rsa_hybrid_decrypt.sh step2a keys/privada.pem ephemereal_key.enc ephemereal_key_descifrada.txt
    PRIVKEY="${2:?Falta la clave privada}"
    INFILE="${3:?Falta ephemereal_key.enc}"
    OUTFILE="${4:?Falta el fichero de salida}"

    echo "[*] Descifrando clave AES efimera con RSA..."
    openssl pkeyutl -decrypt -inkey "$PRIVKEY" -in "$INFILE" -out "$OUTFILE"
    cat "$OUTFILE"
    ;;

  step2b)
    # ./04_rsa_hybrid_decrypt.sh step2b ephemereal_key_descifrada.txt contraseña.txt.aes2 contraseña.txt.aes2_descifrada.txt
    KEYFILE="${2:?Falta el fichero con la clave AES descifrada}"
    INFILE="${3:?Falta el fichero cifrado con AES}"
    OUTFILE="${4:?Falta el fichero de salida}"

    echo "[*] Descifrando ${INFILE} con AES-256-CBC usando la clave de ${KEYFILE}..."
    openssl enc -aes-256-cbc -pbkdf2 -d -pass "file:${KEYFILE}" -in "$INFILE" -out "$OUTFILE"
    cat "$OUTFILE"
    ;;

  *)
    echo "Paso desconocido: $STEP (usa 'step1', 'step2a' o 'step2b')"
    exit 1
    ;;
esac
