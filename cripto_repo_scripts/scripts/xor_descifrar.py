#!/usr/bin/env python3
"""
xor_descifrar.py
Descifra el fichero "secret.txt" generado por xor.py.

Formato del fichero (segun xor.py):
  - El texto cifrado esta en Base64.
  - Los primeros y ultimos 4 caracteres del Base64 son bytes
    aleatorios añadidos como "ruido".
  - El nucleo restante esta INVERTIDO.
  - Tras decodificar Base64 e invertir, el texto se obtiene
    aplicando XOR con la clave "abcdefgh:12345678".

Uso:
    python3 xor_descifrar.py [fichero]

Si no se especifica fichero, usa "secret.txt" en el directorio actual.
"""

import base64
import sys

KEY = "abcdefgh:12345678"


def descifrar(path: str) -> str:
    with open(path, "r") as f:
        data = f.read().strip()

    # Los primeros y ultimos 4 caracteres son ruido aleatorio en Base64
    core = data[4:-4]

    # Invertir la cadena
    rev = core[::-1]

    # Decodificar Base64
    decoded = base64.b64decode(rev).decode("utf-8")

    # Descifrar usando XOR con la clave repetida
    plaintext = ""
    for i in range(len(decoded)):
        plaintext += chr(ord(decoded[i]) ^ ord(KEY[i % len(KEY)]))

    return plaintext


if __name__ == "__main__":
    fichero = sys.argv[1] if len(sys.argv) > 1 else "secret.txt"
    resultado = descifrar(fichero)
    print("Texto original:", resultado)
