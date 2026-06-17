#!/usr/bin/env bash
# 01_reconocimiento_sniffing.sh
#
# Fase 1: identificación de las máquinas en la red NAT y captura de
# tráfico para detectar la comunicación cliente-servidor.

# Captura de tráfico en la interfaz eth0 (lanzar antes de levantar las
# máquinas víctima/cliente para no perder los primeros paquetes)
wireshark -i eth0 &

# Identificación de hosts activos en la red local
sudo arp-scan --localnet -I eth0

# En Wireshark, filtrar por ICMP/ARP para observar los intentos de
# conexión entre las máquinas detectadas, p. ej.:
#   icmp || arp
