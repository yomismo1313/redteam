#!/usr/bin/env python3
"""
affine_hex_decrypt.py
Descifra el fichero "msg2.enc" (usuario encrypt9), que contiene un
cifrado afin sobre bytes representados en hexadecimal.

El script original "chall_crypto.py" fallaba por una dependencia
faltante ("secretfile"), pero el cifrado se puede invertir
directamente: cada byte 'b' del texto cifrado se transforma como

    plaintext_char = chr(((b - 18) * 179) % 256)

Uso:
    python3 affine_hex_decrypt.py msg2.enc

(equivalente al one-liner usado en el writeup:)
    python3 -c "ct=open('msg2.enc').read().strip(); \
print(' '.join(chr(((b-18)*179)%256) for b in bytes.fromhex(ct)))"
"""

import sys


def decrypt(hexstring: str) -> str:
    ct = bytes.fromhex(hexstring.strip())
    return "".join(chr(((b - 18) * 179) % 256) for b in ct)


if __name__ == "__main__":
    path = sys.argv[1] if len(sys.argv) > 1 else "msg2.enc"
    with open(path, "r") as f:
        hexstring = f.read()

    print(decrypt(hexstring))
