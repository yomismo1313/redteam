# Ejercicio de Criptografía: codificaciones, cifrados clásicos, OpenSSL, RSA/AES e ingeniería inversa de un XOR

Writeup de un reto progresivo de **criptografía aplicada** en el que se escala a través de **30 usuarios** mediante codificaciones, cifrados clásicos, cifrado simétrico (OpenSSL), cifrado híbrido RSA+AES, funciones hash y, finalmente, ingeniería inversa de un script Python con cifrado XOR.

**Herramientas de apoyo:** [cryptii.com](https://cryptii.com) y [dcode.fr](https://dcode.fr) para decodificaciones rápidas (César, Vigenère, sustitución alfabética, binario, URL encoding...), además de `openssl`, `hash-identifier` y `hashcat`.

## Resumen del flujo

```
ubuntu (10.0.2.12)
  │
  ├─ Codificaciones (encode1 → encode8)
  │    rev → base64 → base64 invertido → hex → decimal → URL encoding → binario
  │
  ├─ Cifrados clásicos (encrypt1 → encrypt5)
  │    César → sustitución alfabética → transposición → Vigenère
  │
  ├─ Cifrado simétrico OpenSSL (encrypt5 → encrypt7)
  │    3DES → AES-256-CBC
  │
  ├─ Cifrado asimétrico / híbrido (pkencrypt1 → pkencrypt3)
  │    RSA directo → híbrido RSA+AES (clave efímera)
  │
  ├─ Funciones hash (hashing1 → hashing6)
  │    MD5 → SHA-1 → SHA-256 → SHA-512 → hashcat (MD5)
  │
  └─ Ingeniería inversa (encrypt8 → encrypt9)
       XOR + Base64 invertido + ruido aleatorio → cifrado afín hexadecimal
```

## Tabla de usuarios y credenciales

| Usuario | Contraseña | Técnica para obtenerla |
|---|---|---|
| `encode1` | `encode1` | Texto plano en `info.txt` |
| `encode2` | `revers3D` | Texto invertido (`rev`) |
| `encode3` | `B4se64` | Base64 |
| `encode4` | `D3sreveR46es4B` | Base64 invertido |
| `encode5` | `H3xToT3xt` | Hexadecimal → ASCII (`xxd -r -p`) |
| `encode6` | `ASD3cimalCI` | Decimal (cryptii.com) |
| `encode7` | `URL<'#'>Encoding` | URL Encoding (cryptii.com) |
| `encode8` | `Text2Binary` | Binario → entero (cryptii.com) |
| `encrypt1` | `encrypt1` | Texto plano en `flag_mid.txt` |
| `encrypt2` | `CaesarKn0w` | Cifrado César, 17 posiciones |
| `encrypt3` | `SustituyeME` | Sustitución alfabética |
| `encrypt4` | `NotSoEasy` | Transposición columnar (clave `TRANSPOSE`) |
| `encrypt5` | `EncryptITVigenere` | Cifrado Vigenère (clave `Vigenere`) |
| `encrypt6` | `3DESEncription!` | OpenSSL 3DES (pass `Symmetric`) |
| `encrypt7` | `AESEncrypt256` | OpenSSL AES-256-CBC (pass `AES256Symmetric`) |
| `encrypt8` | `-H@rdl3v3l!!` | Texto plano en `credentials.txt` (vía hashing6) |
| `encrypt9` | `anagrama:amargana` | Ingeniería inversa de `xor.py` |
| `pkencrypt1` | `pkencrypt1` | Texto plano en `flag_mid.txt` |
| `pkencrypt2` | `Dec0deASPrivate` | RSA directo (`openssl pkeyutl -decrypt`) |
| `pkencrypt3` | `KeyExchangeEPH` | Cifrado híbrido RSA + AES |
| `hashing1` | `hashing1` | Texto plano en `flag_mid.txt` |
| `hashing2` | `Check1ngMD5` | Hash MD5 → coincide con `contraseña7.txt` |
| `hashing3` | `Check1ngSHA1` | Hash SHA-1 → coincide con `contraseña4.txt` |
| `hashing4` | `BDHey23dsfad890bSHDYsm` | Hash SHA-256 → coincide con `contraseña8.txt` |
| `hashing5` | `BDHasDFHsydnbSHDYsm` | Hash SHA-512 → coincide con `contraseña9.txt` |
| `hashing6` | `admin123` | Fuerza bruta MD5 con `hashcat` |

---

## 0. Acceso inicial

Desde Kali, en la misma red NAT, se descubre la máquina víctima:

```bash
sudo arp-scan --interface=eth0 --localnet
```

Se identifica la IP **10.0.2.12** (Ubuntu). Se conecta vía SSH con las credenciales por defecto:

```bash
ssh ubuntu@10.0.2.12
# password: ubuntu
```

Tras el acceso, `ls -la` y `cat info.txt` revelan en texto plano las credenciales del primer usuario del reto: **`encode1` / `encode1`**.

![Descubrimiento de red, SSH y primer fichero info.txt](screenshots/page_01.png)

---

## 1. Cadena de codificaciones (encode1 → encode8)

### encode1 → encode2 — Texto invertido

`cat contraseña.txt` muestra una frase en texto plano pero **invertida**. Se revierte con `rev`:

```bash
echo "D3srever se 2edocne ed añesartnoc aL" | rev
# → La contraseña de encode2 es revers3D
```

### encode2 → encode3 — Base64

```bash
echo "TGEgY29udHJhc2XDsWEgZGUgZW5jb2RlMyBlcyBCNHNlNjQK" | base64 -d
# → La contraseña de encode3 es B4se64
```

### encode3 → encode4 — Base64 invertido

El contenido está invertido **y** codificado en Base64. Se aplica `rev` y luego `base64 -d`:

```bash
cat contraseña.txt | rev | base64 --decode
# → La contraseña de encode4 es D3sreveR46es4B
```

![Codificaciones encode1 a encode4: rev, base64, base64 invertido y hexadecimal](screenshots/page_02.png)

### encode4 → encode5 — Hexadecimal

```bash
echo "4C 61 20 63 6F 6E ... 78 74" | xxd -r -p
# → La contraseña de encode5 es H3xToT3xt
```

### encode5 → encode6 — Decimal

`contraseña.txt` contiene una secuencia de números decimales (cada uno, el código ASCII de un carácter). Se decodifica en **cryptii.com**, seleccionando *"Entero"* → *Descifrar*:

```
76 97 32 99 111 110 116 ... → La contraseña de encode6 es ASD3cimalCI
```

![Decodificación decimal en cryptii.com](screenshots/page_03.png)

### encode6 → encode7 — URL Encoding

```
La%20contrase%C3%B1a%20de%20encode7%20es%20URL%3C%27%23%27%3EEncoding
```

Decodificado en cryptii.com (*"Url encoding"* → *Descifrar*):

```
→ La contraseña de encode7 es URL<'#'>Encoding
```

### encode7 → encode8 — Binario

`contraseña.txt` contiene una larga cadena de bytes en binario. Decodificado en cryptii.com (*Binary* → *Integer* → *Text*):

```
→ La contraseña de encode8 es Text2Binary
```

![Cifrado URL encoding y binario, ambos resueltos en cryptii.com](screenshots/page_04.png)

### encode8 — flag_mid.txt

```bash
cd /home/encode8 && cat flag_mid.txt
```

```
Continua con los ejercicios de cifrado
  - Usuario: encrypt1
  - Contraseña: encrypt1
```

---

## 2. Cifrados clásicos (encrypt1 → encrypt5)

### encrypt1 → encrypt2 — Cifrado César

```bash
cat contraseña.txt
# Cr tfekirjvñr uv vetipgk2 vj TrvjriBe0n
```

Decodificado en cryptii.com con *"Caesar cipher"*, desplazamiento de **17 posiciones**:

```
→ La contraseña de encrypt2 es CaesarKn0w
```

![Cifrado César con 17 posiciones de desplazamiento](screenshots/page_04.png)

### encrypt2 → encrypt3 — Sustitución alfabética

Se proporciona un par de ficheros de referencia (`ejemplo.txt` / `ejemplo.txt.enc`) con un texto de prueba y su versión cifrada. Comparando ambos carácter a carácter se reconstruye la tabla de sustitución:

| Alfabeto Simple | A | B | C | D | E | F | I | L | M | N | O | P | Q | R | S | T | U | Y |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Alfabeto de Texto Cifrado | U | V | W | X | Y | Z | F | I | J | K | L | C | D | E | O | P | Q | M |

Con esta tabla, se introduce el cifrado de `contraseña.txt.enc` en cryptii.com (*"Alphabetical substitution"* → Decode):

```
→ La contraseña del usuario encrypt3 es SustituyeME
```

![Reconstrucción de la tabla de sustitución alfabética](screenshots/page_05.png)

### encrypt3 → encrypt4 — Transposición columnar

`info.txt` indica que el cifrado es de **transposición** y sugiere la clave **`TRANSPOSE`**.

#### Resolución manual

1. Se numeran las letras del alfabeto del 1 al 26.
2. Se asigna a cada letra de la clave `TRANSPOSE` su número correspondiente:

   | T | R | A | N | S | P | O | S | E |
   |---|---|---|---|---|---|---|---|---|
   | 20 | 18 | 1 | 14 | 19 | 16 | 15 | 19 | 5 |

3. Se ordenan las columnas de menor a mayor número y se distribuye el texto cifrado columna por columna.
4. Se reordenan las columnas a su posición original y se lee fila por fila.

Resultado: `Lapassdeencryt4esNotSoEasy` → con espacios: **"La pass de encrypt4 es NotSoEasy"**.

![Resolución manual del cifrado de transposición con clave TRANSPOSE](screenshots/page_06.png)

### encrypt4 → encrypt5 — Cifrado Vigenère

`info.txt` ofrece varios candidatos (Caesar, AlKindi, **Vigenere**, Enigma). Probando **Vigenère** con clave `Vigenere` en cryptii.com:

```
Gi vefw ui zvivltk5 in MtgecgxDBBmtieimm
→ La pass de encrypt5 es EncryptITVigenere
```

![Cifrado Vigenère resuelto con clave "Vigenere"](screenshots/page_07.png)

---

## 3. Cifrado simétrico con OpenSSL (encrypt5 → encrypt7)

### encrypt5 → encrypt6 — 3DES

`contraseña.txt.des3` comienza por **`Salted__`**, indicando cifrado con `openssl enc`. `info.txt` da varios candidatos de contraseña (RC4Encryption, DES3Rules, Symmetric, NotSoEasy...). La correcta es **`Symmetric`**:

```bash
openssl enc -d -des3 -pbkdf2 -in contraseña.txt.des3 -out contraseña_descifrada.txt -k Symmetric
cat contraseña_descifrada.txt
# → La contraseña de encrypt6 es 3DESEncription!
```

### encrypt6 → encrypt7 — AES-256-CBC

`contraseña.txt.aes2` también comienza por `Salted__`. De los candidatos en `info.txt` (RC4Encryption, CBCRules, NotSoEasy, **AES256Symmetric**, Symmetric, ZenAES256), la correcta es **`AES256Symmetric`**:

```bash
openssl enc -aes-256-cbc -pbkdf2 -d -in contraseña.txt.aes2 -out contraseña_descifrada.txt -k AES256Symmetric
cat contraseña_descifrada.txt
# → La contraseña de encrypt7 es AESEncrypt256
```

![Descifrado con OpenSSL 3DES y AES-256-CBC](screenshots/page_08.png)

### encrypt7 — flag_mid.txt

```bash
cat flag_mid.txt
```

```
Continua con los ejercicios de cifrado asimétrico
  - Usuario: pkencrypt1
  - Contraseña: pkencrypt1
```

---

## 4. Cifrado asimétrico e híbrido (pkencrypt1 → pkencrypt3)

### pkencrypt1 → pkencrypt2 — RSA directo

`pkencrypt1` dispone de `contraseña.txt.enc` y un directorio `keys/` con `privada.pem` y `publica.pem`. Se descifra directamente con la clave privada:

```bash
openssl pkeyutl -decrypt -inkey keys/privada.pem -in contraseña.txt.enc -out contraseña_descifrada.txt
cat contraseña_descifrada.txt
# → La contraseña de pkencrypt2 es Dec0deASPrivate
```

### pkencrypt2 → pkencrypt3 — Cifrado híbrido RSA + AES

`pkencrypt2` contiene `contraseña.txt.aes2`, `ephemereal_key.enc` y otro par de claves RSA. Es un esquema **híbrido**: una clave AES efímera cifrada con RSA, y los datos cifrados con esa clave AES.

**Paso 1 — recuperar la clave AES con RSA:**

```bash
openssl pkeyutl -decrypt -inkey keys/privada.pem -in ephemereal_key.enc -out ephemereal_key_descifrada.txt
cat ephemereal_key_descifrada.txt
# VyX76Dnmsny6534jjDM
```

**Paso 2 — usar esa clave para descifrar el fichero AES:**

```bash
openssl enc -aes-256-cbc -pbkdf2 -d -pass file:ephemereal_key_descifrada.txt \
  -in contraseña.txt.aes2 -out contraseña.txt.aes2_descifrada.txt
cat contraseña.txt.aes2_descifrada.txt
# → La contraseña de pkencrypt3 es KeyExchangeEPH
```

![Cifrado híbrido RSA+AES: recuperación de la clave efímera y descifrado final](screenshots/page_09.png)

### pkencrypt3 — flag_mid.txt y bifurcación

```bash
cat flag_mid.txt
```

```
Si has llegado hasta aqui, se abre una nueva via en el reto.
Tú eliges.

- Seguir con los ejercicios de criptografia asimétrica
    - Continúa analizando el fichero contraseña.txt.enc

- Arrancar con los ejercicios de funciones de hash:
    - Usuario: hashing1
    - Contraseña: hashing1
```

> En este writeup se sigue la rama de **funciones hash**.

---

## 5. Funciones hash (hashing1 → hashing6)

El patrón se repite en `hashing1` → `hashing4`: `info.txt` da un hash, y hay que encontrar cuál de los diez ficheros `contraseña1.txt` ... `contraseña10.txt` en `/Creds` produce ese hash. **Solo se pueden probar 2 candidatos antes de bloquear el usuario**, así que primero se identifica el tipo de hash con `hash-identifier`.

### hashing1 → hashing2 — MD5

```bash
hash-identifier 9f75f653a20dba0796f5011dddc34aaa
# → MD5
md5sum Creds/contraseña*.txt
# contraseña7.txt coincide
cat Creds/contraseña7.txt
# → La pass de hashing2 es Check1ngMD5
```

![Identificación de hash MD5 y búsqueda de coincidencia entre ficheros](screenshots/page_10.png)

### hashing2 → hashing3 — SHA-1

```bash
hash-identifier 26ed6139d311e851d4efa906bfc78e90f970cedd
# → SHA-1
sha1sum Creds/contraseña*.txt
# contraseña4.txt coincide
cat Creds/contraseña4.txt
# → La pass de hashing3 es Check1ngSHA1
```

![Identificación de hash SHA-1 y búsqueda de coincidencia](screenshots/page_11.png)

### hashing3 → hashing4 — SHA-256

```bash
sha256sum Creds/contraseña*.txt
# contraseña8.txt coincide con el hash de info.txt
cat Creds/contraseña8.txt
# → La contraseña del usuario hashing4 es BDHey23dsfad890bSHDYsm
```

![Coincidencia de hash SHA-256 con contraseña8.txt](screenshots/page_12.png)

### hashing4 → hashing5 — SHA-512

```bash
hash-identifier 8a2f1de3b96eac2e0687ab9980d450b147aa3cb46ac891c724abaf757495518211ac71b16f59b92e7704ab1f6553e6f9609a977f723abca0f29b10089fe5db44
# → SHA-512
sha512sum Creds/contraseña*.txt
# contraseña9.txt coincide
cat Creds/contraseña9.txt
# → La contraseña del usuario hashing5 es BDHasDFHsydnbSHDYsm
```

### hashing5 → hashing6 — Fuerza bruta MD5 con hashcat

`hashing5` contiene `contraseña_hashing6.md5`, con un hash MD5 sin texto plano conocido:

```bash
hash-identifier 0192023a7bbd73250516f069df18b500
# → MD5
hashcat -m 0 -a 0 hash.txt /usr/share/wordlists/rockyou.txt
hashcat -m 0 hash.txt --show
# 0192023a7bbd73250516f069df18b500:admin123
```

![Fuerza bruta con hashcat resolviendo el hash MD5 de hashing6](screenshots/page_13.png)

La contraseña de `hashing6` es **`admin123`**.

### hashing6 — credentials.txt

```bash
cat credentials.txt
```

```
user: encrypt8
password: -H@rdl3v3l!!
```

![Acceso a hashing6 y obtención de credenciales para encrypt8](screenshots/page_14.png)

---

## 6. Ingeniería inversa de un cifrado XOR (encrypt8 → encrypt9)

`encrypt8` contiene `secret.txt`, `secret_1.txt`, y el script que **genera** esos ficheros: `xor.py`.

```python
def xorEncryption(key, plaintext):
    ciphertext = ""
    for i in range(len(plaintext)):
        ciphertext += chr(ord(plaintext[i]) ^ ord(key[i]))
    ciphertext = base64.b64encode(bytes(ciphertext, encoding="utf-8")).decode()[::-1]
    random_bytes = base64.b64encode(bytes(chr(random.randint(0, 255)), encoding="utf-8")).decode()
    ciphertext = random_bytes + ciphertext + random_bytes
    return ciphertext
```

**Lógica de cifrado** (y, por tanto, de descifrado en orden inverso):

1. XOR del texto plano con la clave `"abcdefgh:12345678"`.
2. Codificación en Base64.
3. **Inversión** de la cadena Base64.
4. Se añaden **4 bytes aleatorios** (ruido) al principio y al final.

Para descifrar, se invierte cada paso en orden contrario: quitar el ruido (4 caracteres a cada lado) → invertir la cadena → decodificar Base64 → XOR con la misma clave.

![Análisis del script xor.py y los ficheros cifrados secret.txt / secret_1.txt](screenshots/page_14.png)

### Script de descifrado: `xor_descifrar.py`

```python
import base64

with open("secret.txt", "r") as f:
    data = f.read().strip()

# Los primeros y ultimos 4 caracteres son ruido aleatorio en Base64
core = data[4:-4]

# Invertir la cadena
rev = core[::-1]

# Decodificar Base64
decoded = base64.b64decode(rev).decode("utf-8")

# Clave usada para XOR
key = "abcdefgh:12345678"

# Descifrar usando XOR
plaintext = ""
for i in range(len(decoded)):
    plaintext += chr(ord(decoded[i]) ^ ord(key[i % len(key)]))

print("Texto original:", plaintext)
```

```bash
chmod +x xor_descifrar.py
python3 xor_descifrar.py
# Texto original: anagrama:amargana
```

![Script xor_descifrar.py y resultado del descifrado](screenshots/page_15.png)

---

## 7. encrypt9 — Cifrado afín hexadecimal

`encrypt9` contiene `msg2.enc` (una cadena hexadecimal) y un script `chall_crypto.py` que falla con:

```
ModuleNotFoundError: No module named 'secretfile'
```

(el script importaba una variable `MSG` desde un módulo inexistente). En lugar de reparar el script, se descifra **directamente desde la terminal**, deduciendo la transformación afín inversa byte a byte:

```bash
python3 -c "ct=open('msg2.enc').read().strip(); print(' '.join(chr(((b-18)*179)%256) for b in bytes.fromhex(ct)))"
```

**Resultado:**

```
Lo conseguiste! Aplica ROT5 a tu nombre y escribelo por slack!
```

![Error del script original y descifrado manual del cifrado afín hexadecimal](screenshots/page_16.png)

---

## Herramientas online utilizadas

| Herramienta | Uso en este reto |
|---|---|
| [cryptii.com](https://cryptii.com) | Decimal/Integer, URL Encoding, Binario, Cifrado César, Sustitución alfabética, Cifrado Vigenère |
| [dcode.fr](https://dcode.fr) | Apoyo adicional para identificación y análisis de cifrados clásicos |
| `hash-identifier` | Identificación del tipo de hash (MD5, SHA-1, SHA-256, SHA-512) |
| `hashcat` | Ataque de diccionario contra hashes MD5 |
| `openssl` | Descifrado simétrico (3DES, AES-256-CBC) y asimétrico (RSA, `pkeyutl`) |

## Conclusión

Este reto recorre de forma progresiva el espectro completo de la criptografía aplicada: desde **codificaciones triviales** (Base64, hexadecimal, binario, URL encoding) hasta **cifrados clásicos** (César, sustitución, transposición, Vigenère), pasando por **cifrado simétrico moderno** (3DES, AES-256 vía OpenSSL), **cifrado híbrido asimétrico** (RSA + AES con clave efímera), **funciones hash** (MD5, SHA-1/256/512) con verificación por fuerza bruta, y finalmente **ingeniería inversa** de un esquema de cifrado XOR personalizado y de un cifrado afín, sin contar con el script de descifrado original.

La progresión refleja de forma didáctica la evolución histórica y técnica de la criptografía, y refuerza la importancia de saber identificar un esquema de cifrado a partir de sus artefactos (prefijos como `Salted__`, estructura de claves RSA, patrones en Base64, etc.) cuando no se dispone de documentación completa.

---

## Disclaimer

Este writeup documenta un ejercicio realizado en un **entorno de laboratorio controlado y aislado** con fines educativos (formación en criptografía aplicada / CTF). No reproduzcas estas técnicas contra sistemas sin autorización explícita.
