#!/bin/bash
FECHA=$(date +%Y%m%d_%H%M%S)
DESTINO="/backup"
ORIGEN="/var/www/html"

mkdir -p "$DESTINO"
tar -czf "$DESTINO/backup_$FECHA.tar.gz" "$ORIGEN"
echo "Backup completado: backup_$FECHA.tar.gz"
