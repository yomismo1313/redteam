# Ubicación original: /home/user2/Documentos/nivel2.py
# Transcrito íntegramente a partir de la captura de pantalla (06...png)

import time

def loading():
    signs = ["|", "/", "-", "\\"]
    for i in range(100):
        print(signs[i % 4].format(i % 4), end='\r')
        time.sleep(0.1)

def menu():
    print("Bienvenido al panel de administración.")
    print("Iniciando el motor de búsqueda")
    loading()

opcion = ''
# La pass de user3 es N0C0mm3nts!
while opcion != 'n':
    menu()
    opcion = input("Parece que el servicio está detenido. ¿Quieres volver a intentarlo? y/n: ")
