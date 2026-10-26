#!/bin/bash
# ==============================================================
# 02 - Enumeración de directorios con Gobuster
# --------------------------------------------------------------
# Fuzzing de directorios y archivos sobre el servidor web objetivo
# para descubrir rutas ocultas y paneles de administración.
#
# Ajusta TARGET_URL antes de ejecutar.
# Requiere la wordlist de dirbuster (instalada por defecto en Kali).
# ==============================================================

set -e

TARGET_URL="http://10.0.2.26/"
WORDLIST="/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt"
EXTENSIONS="bak,zip,php,txt,pdf"

echo "[*] Lanzando Gobuster contra ${TARGET_URL}..."
gobuster dir \
  -u "${TARGET_URL}" \
  -w "${WORDLIST}" \
  -x "${EXTENSIONS}"

# -u  URL objetivo
# -w  Wordlist de rutas a probar
# -x  Extensiones de archivo a buscar además de directorios
