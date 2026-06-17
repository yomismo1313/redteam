# Ubicación original: /home/user4/Documentos/nivel4.py
# Transcrito íntegramente a partir de la captura de pantalla (08...png)
# Se ejecuta exigiendo argumentos extra y la palabra clave "debug" en
# la posición 4, p. ej.: python3 nivel4.py a b c debug

import sys
import time
import base64

def decode():
    base64_message = 'UEByYW1ldDNycw=='
    message_bytes = base64.b64decode(base64_message)
    message = message_bytes.decode('ascii')
    return message

def loading():
    signs = ["|", "/", "-", "\\"]
    for i in range(40):
        print(signs[i % 4].format(i % 4), end='\r')
        time.sleep(0.1)

def menu():
    print("Bienvenido al panel de administración.")
    print("Iniciando el motor de búsqueda")
    loading()

args = sys.argv
menu()

if (len(args) % 2 == 0) and (args[4] == 'debug'):
    print("La pass de user5 es: " + decode())
else:
    print("Parece que el servicio está detenido. Vuelve a intentarlo")
