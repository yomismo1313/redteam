#!/usr/bin/env bash
#
# 02_generate_wordlist.sh
# Genera un diccionario de contraseñas personalizado a partir del
# contenido textual de la web objetivo usando CeWL, para usarlo
# después como payload en Burp Suite Intruder.
#
# Uso:
#   ./02_generate_wordlist.sh <url_objetivo> [salida.txt]
#
# Ejemplo:
#   ./02_generate_wordlist.sh http://10.0.2.16:8080 cewl.txt
#
# Flags de cewl empleados:
#   --with-numbers : incluye números encontrados en el sitio
#   -m             : longitud mínima de palabra
#   -x             : longitud máxima de palabra
#   -d             : profundidad de rastreo (crawl depth)
#   -w             : fichero de salida
#
set -euo pipefail

URL="${1:?Uso: $0 <url_objetivo> [salida.txt]}"
OUT="${2:-cewl.txt}"

cewl "${URL}" --with-numbers -m 3 -x 8 -d 2 -w "${OUT}"

echo "[+] Diccionario generado en: ${OUT}"
echo "[*] Cárgalo en Burp Suite Intruder -> Payloads -> Payload configuration -> Load..."
