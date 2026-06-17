# Ubicación original: /home/user6/Documentos/nivel6.py
# Transcrito a partir de la captura de pantalla (11...png).
# NOTA: el "cat" se cortó en la terminal antes de mostrar el final
# del script, por lo que esta transcripción es PARCIAL. La constante
# en base64 decodifica a la pass de user7 ("=0neM1llion").

import os
import time
import base64

def decode():
    base64_message = 'PTBuZU0xbGxpb24='
    message_bytes = base64.b64decode(base64_message)
    message = message_bytes.decode('ascii')
    return message

def loading():
    signs = ["|", "/", "-", "\\"]
    for i in range(100):
        print(signs[i % 4].format(i % 4), end='\r')
        time.sleep(0.1)

def register_user(mail):
    file = open('.registered_users.db', 'a')
    file.write(mail + "\n")

def verify_win():
    file = open('.registered_users.db', 'r').readlines()
    return (len(file) == 1000000)

path = ".registered_users.db"

print("Bienvenido al concurso 1.000.000")
print("Regístrate para ganar un fantástico premio. ¿Serás tu el participante 1.000.000?")

# --- El resto del script no es visible en la captura disponible ---
