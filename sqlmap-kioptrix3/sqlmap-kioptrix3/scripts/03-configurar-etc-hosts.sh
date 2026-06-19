#!/bin/bash
# ==============================================================
# 03 - Resolver el dominio kioptrix3.com en /etc/hosts
# --------------------------------------------------------------
# La aplicación Gallarific de la galería carga recursos usando
# el nombre de dominio kioptrix3.com. Sin esta entrada, las
# páginas no se renderizan correctamente desde Kali.
# ==============================================================

set -e

TARGET_IP="10.0.2.26"
HOSTNAME="kioptrix3.com"
HOSTS_FILE="/etc/hosts"

if grep -q "${HOSTNAME}" "${HOSTS_FILE}"; then
  echo "[!] La entrada ya existe en ${HOSTS_FILE}:"
  grep "${HOSTNAME}" "${HOSTS_FILE}"
else
  echo "[*] Añadiendo ${TARGET_IP} ${HOSTNAME} a ${HOSTS_FILE}..."
  echo "${TARGET_IP}    ${HOSTNAME}" | sudo tee -a "${HOSTS_FILE}"
  echo "[+] Entrada añadida correctamente."
fi
