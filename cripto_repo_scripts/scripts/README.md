# Scripts del reto de Criptografía

Scripts y comandos de referencia usados para resolver cada fase del
reto, documentado en [../README.md](../README.md). Cada script puede
ejecutarse de forma independiente; ejecútalo sin argumentos para ver
el uso.

| Script | Fase | Descripción |
|---|---|---|
| `01_encoding_chain.sh` | encode1 → encode8 | Comandos de referencia para la cadena de codificaciones (rev, base64, hex, decimal, URL encoding, binario) |
| `02_transposition_solver.py` | encrypt3 → encrypt4 | Resuelve un cifrado de transposición columnar dada una clave (ej. `TRANSPOSE`) |
| `03_openssl_decrypt.sh` | encrypt5 → encrypt7 | Descifra ficheros OpenSSL `Salted__` con 3DES o AES-256-CBC |
| `04_rsa_hybrid_decrypt.sh` | pkencrypt1 → pkencrypt3 | Descifrado RSA directo y esquema híbrido RSA+AES (clave efímera) |
| `05_hash_match.sh` | hashing1 → hashing5 | Identifica el tipo de hash y busca qué fichero de credenciales coincide |
| `06_hashcat_crack.sh` | hashing5 → hashing6 | Ataque de diccionario con hashcat sobre un hash MD5 |
| `07_affine_hex_decrypt.py` | encrypt9 | Descifra `msg2.enc` (cifrado afín sobre bytes hexadecimales) |
| `xor_descifrar.py` | encrypt8 → encrypt9 | Descifra `secret.txt` (XOR + Base64 invertido + ruido aleatorio) |

## Requisitos previos

- `bash`, `python3`
- `hash-identifier`, `hashcat` (Kali Linux las incluye por defecto)
- `openssl`
- Acceso a [cryptii.com](https://cryptii.com) para los pasos que se
  resolvieron vía web (Cifrado César, Vigenère, sustitución
  alfabética, URL encoding, binario↔entero) — ver tabla de
  herramientas online en el README principal

## Dar permisos de ejecución

```bash
chmod +x *.sh *.py
```

## Resumen rápido por fase

```bash
# encode1 -> encode8: ver 01_encoding_chain.sh (comandos de referencia)
cat contraseña.txt | rev                    # encode1 -> encode2
echo "<cifrado>" | base64 -d                # encode2 -> encode3
cat contraseña.txt | rev | base64 -d        # encode3 -> encode4
echo "<cifrado>" | xxd -r -p                 # encode4 -> encode5
# encode5 -> encode8: resuelto en cryptii.com (decimal, URL encoding, binario)

# encrypt1 -> encrypt2: Cifrado César, 17 posiciones -> cryptii.com
# encrypt2 -> encrypt3: Sustitución alfabética -> cryptii.com (tabla en README)

# encrypt3 -> encrypt4: transposición con clave TRANSPOSE
python3 02_transposition_solver.py TRANSPOSE "<cifrado_sin_espacios>"

# encrypt4 -> encrypt5: Cifrado Vigenère, clave "Vigenere" -> cryptii.com

# encrypt5 -> encrypt6: OpenSSL 3DES, pass "Symmetric"
./03_openssl_decrypt.sh des3 contraseña.txt.des3 contraseña_descifrada.txt Symmetric

# encrypt6 -> encrypt7: OpenSSL AES-256, pass "AES256Symmetric"
./03_openssl_decrypt.sh aes256 contraseña.txt.aes2 contraseña_descifrada.txt AES256Symmetric

# pkencrypt1 -> pkencrypt2: RSA directo
./04_rsa_hybrid_decrypt.sh step1 keys/privada.pem contraseña.txt.enc contraseña_descifrada.txt

# pkencrypt2 -> pkencrypt3: hibrido RSA+AES
./04_rsa_hybrid_decrypt.sh step2a keys/privada.pem ephemereal_key.enc ephemereal_key_descifrada.txt
./04_rsa_hybrid_decrypt.sh step2b ephemereal_key_descifrada.txt contraseña.txt.aes2 contraseña.txt.aes2_descifrada.txt

# hashing1 -> hashing5: identificar hash y buscar coincidencia en Creds/
./05_hash_match.sh <hash_de_info.txt> md5sum    Creds/
./05_hash_match.sh <hash_de_info.txt> sha1sum   Creds/
./05_hash_match.sh <hash_de_info.txt> sha256sum Creds/
./05_hash_match.sh <hash_de_info.txt> sha512sum Creds/

# hashing5 -> hashing6: fuerza bruta con hashcat
./06_hashcat_crack.sh <hash_md5_de_contraseña_hashing6.md5>

# encrypt8 -> encrypt9: descifrar XOR
python3 xor_descifrar.py secret.txt

# encrypt9: descifrar msg2.enc (cifrado afin)
python3 07_affine_hex_decrypt.py msg2.enc
```

> **Nota:** estos scripts están pensados para un entorno de laboratorio
> aislado y controlado, con fines educativos (formación en
> criptografía aplicada / CTF). No los uses contra sistemas sin
> autorización explícita.
