#!/usr/bin/env bash
# 02_extraccion_credenciales_http.sh
#
# Fase 2: localización en Wireshark de la petición HTTP con
# credenciales en texto claro y acceso al panel resultante.
#
# En Wireshark:
#   1. Buscar el paquete con "POST /login.php HTTP/1.1"
#      (filtro de display: http.request.method == "POST")
#   2. Clic derecho -> Follow -> HTTP Stream
#   3. Leer el cuerpo de la petición en texto plano:
#
#      POST /login.php HTTP/1.1
#      Host: 10.0.2.8:32013
#      ...
#      usuario=admin & palabra_secreta=LaBarbacoa
#
# Con esas credenciales se accede vía navegador (o curl) al panel:
curl "http://10.0.2.8:32013/login.php" \
  --data "usuario=admin & palabra_secreta=LaBarbacoa"

# El panel autenticado expone la URL con las "puertas" del portknocking:
#   http://10.0.2.8:32013/secreta.php
# Puertas mostradas: 7003, 8004, 9005
