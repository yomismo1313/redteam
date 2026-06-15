#!/usr/bin/env python3
"""
transposition_solver.py
Descifra un cifrado de transposicion columnar (cifrado en columnas)
dada una palabra clave (ej. "TRANSPOSE").

Funcionamiento (cifrado columnar clasico):
  1. La clave define un orden de columnas, segun la posicion
     alfabetica de cada letra de la clave.
  2. El texto cifrado se escribe en una tabla, columna por columna,
     siguiendo el orden alfabetico de la clave.
  3. Para descifrar, se reconstruye la tabla y se lee fila por fila.

Uso:
    python3 transposition_solver.py <CLAVE> <TEXTO_CIFRADO>

Ejemplo (del writeup, usuario encrypt3 -> encrypt4):
    python3 transposition_solver.py TRANSPOSE "peadtsetSlAEryacnNtspoosen"

Si el resultado no es legible, prueba a invertir el orden de lectura
(fila/columna) ajustando el parametro --mode.
"""

import sys
import argparse


def col_order(key: str):
    """Devuelve el orden de columnas (0-indexado) segun el orden
    alfabetico de las letras de la clave."""
    indexed = sorted(range(len(key)), key=lambda i: key[i])
    # 'indexed' nos da, para cada posicion en orden alfabetico, la
    # columna original correspondiente.
    return indexed


def decrypt_columnar(key: str, ciphertext: str) -> str:
    n = len(key)
    rows = -(-len(ciphertext) // n)  # ceil division
    order = col_order(key)

    # Reparte el texto cifrado en columnas, en el orden alfabetico
    # de la clave (orden en que fueron escritas las columnas).
    table = [["" for _ in range(n)] for _ in range(rows)]
    idx = 0
    for col_alpha_pos in range(n):
        original_col = order[col_alpha_pos]
        for r in range(rows):
            if idx < len(ciphertext):
                table[r][original_col] = ciphertext[idx]
                idx += 1

    # Lee la tabla fila por fila, en el orden original de columnas
    return "".join(table[r][c] for r in range(rows) for c in range(n) if table[r][c])


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("key", help="Palabra clave, ej: TRANSPOSE")
    parser.add_argument("ciphertext", help="Texto cifrado (sin espacios)")
    args = parser.parse_args()

    key = args.key.upper()
    ct = args.ciphertext.strip()

    result = decrypt_columnar(key, ct)
    print("Resultado:", result)
    print()
    print("Si el texto no es legible, revisa el numero de filas/columnas")
    print("o intenta leer la tabla por columnas en vez de por filas.")
