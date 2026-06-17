# Ubicación original: /home/user3/Documentos/nivel3.py
# Transcrito íntegramente a partir de la captura de pantalla (06...png)

import requests
import base64

def decode():
    base64_message = 'SDRyZEMwZGU='
    message_bytes = base64.b64decode(base64_message)
    message = message_bytes.decode('ascii')
    return message

def menu():
    print("Bienvenido al panel de administración.")
    print("Iniciando el motor de búsqueda")

menu()

user = input("Introduce el nombre de usuario: ")
passw = input("Introduce la pass: ")

if (user == "devadmin") and (passw == "H4rdC0ding&F4il"):
    print("La pass de user4 es: " + decode())
else:
    print("El usuario no existe")
