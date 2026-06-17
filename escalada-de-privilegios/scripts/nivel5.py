# Ubicación original: /home/user5/Documentos/nivel5.py
# Transcrito íntegramente a partir de la captura de pantalla (10...png)
# La clave de validación se obtiene de la penúltima línea de un
# fichero de texto alojado en un Gist público (trollface.txt).

import requests
import base64

def decode():
    base64_message = 'RXh0M3JuYWxLM1k='
    message_bytes = base64.b64decode(base64_message)
    message = message_bytes.decode('ascii')
    return message

response = requests.get('https://gist.githubusercontent.com/poundifdef/fd0901799a4aeb3a1f3956cfdb3c7746/raw/36f07f44ba9f80eb93fbb336e2bdf4096adeb484/trollface.txt')
key = str(response.text).split('\n')[-2].strip()

user_response = str(input("¿Cómo puedo ayudarte? \n"))

if user_response == key:
    print("La pass de user6 es: " + decode())
else:
    print("No puedo ayudarte con eso")
