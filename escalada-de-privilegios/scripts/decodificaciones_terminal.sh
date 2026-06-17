#!/usr/bin/env bash
# decodificaciones_terminal.sh
#
# Recopilatorio de los comandos de una línea usados directamente en la
# terminal (no son ficheros del reto, sino comandos propios) para
# decodificar las credenciales obtenidas de los scripts nivelX.py.
# Se documentan aquí a modo de referencia rápida del flujo seguido.

# Pass de user4 (a partir de nivel3.py)
echo "SDRyZEMwZGU=" | base64 -d
# -> H4rdC0de

# Pass de user5 (a partir de nivel4.py)
echo "UEByYW1ldDNycw==" | base64 -d
# -> P@ramet3rs

# Pass de user7 (a partir de nivel6.py)
echo "PTBuZU0xbGxpb24=" | base64 -d
# -> =0neM1llion

# Pass de user8 (a partir de nivel7_srv.py)
echo "TGEgcGFzcyBkZSB1c2VyOCBlczogVENQIVMwY2szdA==" | base64 -d
# -> La pass de user8 es: TCP!S0ck3t

# Pass de user9 (a partir de nivel8.py)
echo "TjB0UzBSYW5kMG0h" | base64 -d
# -> N0tS0Rand0m!

# Pass de user10 (a partir de nivel9.py) — hexadecimal invertido
echo -n "6e695726737669697250796669646f4d" | xxd -r -p | rev
# -> ModifyPrivs&Win
