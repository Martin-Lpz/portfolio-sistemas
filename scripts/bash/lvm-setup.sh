#!/bin/bash
# Comandos LVM - lab 09
pvcreate /dev/sdb
vgcreate vg_datos /dev/sdb
lvcreate -L 5G -n lv_datos vg_datos
mkfs.ext4 /dev/vg_datos/lv_datos
mount /dev/vg_datos/lv_datos /mnt/datos
echo "LVM configurado correctamente"
