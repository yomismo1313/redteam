#!/bin/bash
# 09_web_enum.sh
# Enumeracion de directorios web a traves de un proxy SOCKS,
# con gobuster (recomendado para multiples saltos) o dirb.
#
# Uso:
#   ./09_web_enum.sh gobuster <url> <wordlist> <socks_port> [extensiones]
#   ./09_web_enum.sh dirb     <url> <wordlist>
#
# Ejemplos:
#   ./09_web_enum.sh gobuster http://10.0.3.5 /usr/share/wordlists/dirb/common.txt 1080
#   ./09_web_enum.sh gobuster http://10.0.5.5 /usr/share/wordlists/dirb/common.txt 1082 txt,html,zip
#   ./09_web_enum.sh dirb http://10.0.4.5:8080 /usr/share/wordlists/dirb/common.txt

set -euo pipefail

TOOL="${1:?Uso: $0 <gobuster|dirb> <url> <wordlist> [socks_port] [extensiones]}"

case "$TOOL" in
  gobuster)
    URL="${2:?Falta la URL}"
    WORDLIST="${3:?Falta la wordlist}"
    SOCKS_PORT="${4:?Falta el puerto SOCKS}"
    EXT="${5:-}"

    EXT_ARGS=()
    if [ -n "$EXT" ]; then
        EXT_ARGS=(-x "$EXT")
    fi

    echo "[*] gobuster contra ${URL} via socks5://127.0.0.1:${SOCKS_PORT} ..."
    gobuster dir -u "$URL" -w "$WORDLIST" "${EXT_ARGS[@]}" \
        --proxy "socks5://127.0.0.1:${SOCKS_PORT}" -o gobuster.txt
    ;;

  dirb)
    URL="${2:?Falta la URL}"
    WORDLIST="${3:?Falta la wordlist}"

    echo "[*] dirb contra ${URL} via proxychains ..."
    proxychains dirb "$URL" "$WORDLIST"
    ;;

  *)
    echo "Herramienta desconocida: $TOOL (usa 'gobuster' o 'dirb')"
    exit 1
    ;;
esac
