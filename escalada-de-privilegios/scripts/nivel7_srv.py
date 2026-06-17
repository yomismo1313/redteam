# Ubicación original: /home/user7/Documentos/nivel7_srv.py
# Transcrito a partir de la captura de pantalla (13...png).
# NOTA: el "cat" se cortó al final de la terminal, esta transcripción
# es PARCIAL. Es un servidor TCP local que entrega un OTP y,
# presumiblemente, valida ese OTP para revelar la pass de user8.

import socket
import random
import base64

def getotp():
    return str(random.randint(10000000, 99999999))

def decode_pass():
    base64_string = "TGEgcGFzcyBkZSB1c2VyOCBlczogVENQIVMwY2szdA=="
    base64_bytes = base64_string.encode("ascii")

    sample_string_bytes = base64.b64decode(base64_bytes)
    sample_string = sample_string_bytes.decode("ascii")
    return sample_string

conn = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
conn.bind(("127.0.0.1", 8050))
conn.listen(1)
cli, addr = conn.accept()
otp = ""

while True:
    recibido = cli.recv(1024)
    print("Recibo conexion de la IP: " + str(addr[0]) + " Puerto: " + str(addr[1]))
    comando = recibido.decode()

    if comando == "user":
        otp = getotp()
        cli.send(otp.encode())

    # --- El resto del script no es visible en la captura disponible ---
