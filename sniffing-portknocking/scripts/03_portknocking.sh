#!/usr/bin/env bash
# 03_portknocking.sh
#
# Fase 3: comprobación de que no hay puertos visibles, desbloqueo
# mediante portknocking con la secuencia de puertas obtenida del
# panel web, y verificación de los servicios expuestos.

TARGET="10.0.2.8"

# Escaneo inicial: sin -Pn no se detecta ping, sin DNS, verbose.
# Resultado esperado en este punto: 1000 puertos cerrados (sin knock).
sudo nmap -sS -Pn -n -vvv "$TARGET"

# Secuencia de portknocking con las puertas obtenidas en secreta.php
knock "$TARGET" 7003 8004 9005

# Reescaneo: deberían aparecer abiertos 22/ssh, 111/rpcbind, 2049/nfs
sudo nmap -sS -Pn -n -vvv "$TARGET"

# Identificación de versión y detalle de los tres servicios expuestos
nmap -sV -p22,111,2049 \
  --script="ssh-hostkey,rpcinfo,nfs-showmount" \
  "$TARGET"
