# Ubicación original: /home/user9/Documentos/nivel9.py
# Transcrito a partir de la captura de pantalla (16...png).
# NOTA: el inicio del script (definición de get_privs(), commands,
# imports de "date", banner, menu(), etc.) queda fuera de la captura,
# por lo que esta transcripción es PARCIAL y arranca a mitad de una
# función. Implementa un panel con 3 niveles de privilegio
# (low / medium / high); el nivel "medium" expone la pass de user10
# codificada en hexadecimal invertido.

# --- Inicio del script no visible en la captura disponible ---
#         num = num + 1

def execute_low(command):
    if str(command) == "0":
        print(time.strftime("%H:%M:%S", time.localtime()))
    elif str(command) == "1":
        print(date.today().strftime("%d/%m/%Y"))
    else:
        print("Status: active")

def execute_medium(command):
    if str(command) == "0":
        print("User: user10 - Encoded pass: 6e695726737669697250796669646f4d")
    else:
        print("Web Application Server - Port 80")

def execute_high(command):
    if str(command) == "0":
        print("Disk: 65% RAM: 99.7% Network: 5% ")
    elif str(command) == "1":
        print("Hex(Reverse(password))")
    else:
        print("Service stopped")

print("Bienvenido al panel de administración.")
print("Iniciando el motor de búsqueda")
loading()

while True:
    menu()
    command = option = input("Elige opcion: ")

    try:
        command = int(command)

        if (command < 0) or (command > len(commands[get_privs()])):
            print("Comando no implementado")
            break
        else:
            if get_privs() == "high":
                execute_high(command)
            elif get_privs() == "medium":
                execute_medium(command)
            else:
                execute_low(command)

    except ValueError:
        print("Se espera un número como opción")
        break
