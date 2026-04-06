#!/bin/bash
DOMINIO=${1:-"lab.local"}
mkdir -p /etc/ssl/lab

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/ssl/lab/$DOMINIO.key \
  -out /etc/ssl/lab/$DOMINIO.crt \
  -subj "/C=ES/ST=Madrid/L=Madrid/O=Lab/CN=$DOMINIO"

echo "Certificado generado para $DOMINIO"
