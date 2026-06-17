# Ubicación original: /home/user8/Documentos/nivel8.py
# Transcrito a partir de la captura de pantalla (14...png).
# NOTA: el "cat" se cortó justo en el bloque "else:", esta
# transcripción es PARCIAL. Es un mini-juego de adivinar en qué vaso
# está la bolita; la posición correcta se deriva de la hora del
# sistema en el momento de ejecución.

import time
import base64

"""
"""

sentence = [
    "No está mal para ser novat@",
    "La suerte está de tu lado",
    "Esta no la esperaba",
    "Interesante...",
    "He visto gente con suerte... pero nunca tanta como tú",
]

def decode():
    base64_message = 'TjB0UzBSYW5kMG0h'
    message_bytes = base64.b64decode(base64_message)
    message = message_bytes.decode('ascii')
    return message

def loading():
    signs = ["|", "/", "-", "\\"]
    for i in range(40):
        print(signs[i % 4].format(i % 4), end='\r')
        time.sleep(0.1)

def timenow():
    t = time.localtime()
    current_time = time.strftime("%H:%M:%S", t)
    return current_time

def getNewPosition(timeexec, round):
    base = timeexec.split(':')[round % 3]
    position = (int(base) + round) % 3
    return str(position + 1)

win = 0
timeexec = timenow()
print(banner)  # banner no visible en la captura
print(timeexec)
print("¿Puedes adivinar dónde está la bolita 5 veces seguidas?")

for i in range(5):
    print("Estamos reordenando los vasos")
    result = getNewPosition(timeexec, i)
    loading()
    user_option = input("Introduce el número del vaso (1, 2, 3): ")

    if user_option != result:
        print("Sabia que fallarías ¬¬")
        break
    else:
        # --- El resto del script no es visible en la captura disponible ---
        pass
