#!/bin/bash
# 01_encoding_chain.sh
# Comandos de referencia para resolver la cadena de codificaciones
# encode1 -> encode8.
#
# No es un script "todo en uno": cada bloque corresponde a un paso
# del reto y requiere el texto cifrado obtenido en el paso anterior
# (leido del fichero contraseña.txt del usuario correspondiente).
#
# Uso: copia y ejecuta el bloque correspondiente al usuario en el
# que te encuentres, sustituyendo <CIFRADO> por el contenido real
# de contraseña.txt.

set -euo pipefail

echo "=== encode1 -> encode2: cadena invertida (rev) ==="
echo 'cat contraseña.txt'
echo 'echo "<CIFRADO>" | rev'
echo
echo "Ejemplo real:"
echo '$ cat contraseña.txt'
echo 'D3srever se 2edocne ed añesartnoc aL'
echo '$ echo "D3srever se 2edocne ed añesartnoc aL" | rev'
echo '-> La contraseña de encode2 es revers3D'
echo

echo "=== encode2 -> encode3: Base64 ==="
echo 'cat contraseña.txt | base64 -d'
echo
echo "Ejemplo:"
echo '$ echo "TGEgY29udHJhc2XDsWEgZGUgZW5jb2RlMyBlcyBCNHNlNjQK" | base64 -d'
echo '-> La contraseña de encode3 es B4se64'
echo

echo "=== encode3 -> encode4: Base64 invertido ==="
echo '# Primero invertir la cadena, luego decodificar Base64'
echo 'cat contraseña.txt | rev | base64 -d'
echo
echo "Ejemplo (segun el writeup, el orden mostrado fue rev seguido de --decode):"
echo '$ cat contraseña.txt | rev | base64 --decode'
echo '-> La contraseña de encode4 es D3sreveR46es4B'
echo

echo "=== encode4 -> encode5: Hexadecimal -> ASCII ==="
echo 'cat contraseña.txt | xxd -r -p'
echo
echo "Ejemplo:"
echo '$ echo "4C 61 20 63 6F 6E 74 72 61 73 65 F1 61 20 64 65 20 65 6E 63 6F 64 65 35 20 65 73 20 48 33 78 54 6F 54 33 78 74" | xxd -r -p'
echo '-> La contraseña de encode5 es H3xToT3xt'
echo

echo "=== encode5 -> encode6: Decimal (entero) ==="
echo '# El fichero contraseña.txt contiene una lista de numeros decimales'
echo '# separados por espacios, cada uno representando un byte ASCII.'
echo 'cat contraseña.txt'
echo
echo '# Decodificar con Python:'
cat <<'EOF'
python3 -c "
nums = open('contraseña.txt').read().split()
print(''.join(chr(int(n)) for n in nums))
"
EOF
echo "-> La contraseña de encode6 es ASD3cimalCI"
echo "(En el writeup se usó cryptii.com -> 'Integer' -> Decode)"
echo

echo "=== encode6 -> encode7: URL Encoding ==="
echo 'cat contraseña.txt'
echo
echo '# Decodificar con Python (urllib) o con printf:'
echo 'python3 -c "import urllib.parse,sys; print(urllib.parse.unquote(open(\"contraseña.txt\").read().strip()))"'
echo
echo "Ejemplo:"
echo 'La%20contrase%C3%B1a%20de%20encode7%20es%20URL%3C%27%23%27%3EEncoding'
echo "-> La contraseña de encode7 es URL<'#'>Encoding"
echo "(En el writeup se usó cryptii.com -> 'URL encoding' -> Decode)"
echo

echo "=== encode7 -> encode8: Binario -> Texto ==="
echo '# El fichero contraseña.txt contiene una cadena de bytes en binario'
echo '# (grupos de 8 bits separados por espacios).'
echo 'cat contraseña.txt'
echo
echo '# Decodificar con Python:'
cat <<'EOF'
python3 -c "
bits = open('contraseña.txt').read().split()
print(''.join(chr(int(b, 2)) for b in bits))
"
EOF
echo "-> La contraseña de encode8 es Text2Binary"
echo "(En el writeup se usó cryptii.com -> 'Binary' -> Integer -> Decode)"
echo

echo "=== encode8: flag_mid.txt ==="
echo 'cd /home/encode8 && cat flag_mid.txt'
echo '-> Usuario: encrypt1 / Contraseña: encrypt1'
