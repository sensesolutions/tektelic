#!/bin/sh
OLDVERSION="4.0.2"
VERSION="7.1.16.4"
#SWNAME=Kona_Micro_SW_BSP_$VERSION.zip
SWNAME=BSP_$VERSION.zip
DIRNAME=Universal_Kona_SW/BSP_$VERSION

echo "Upgrade software from $OLDVERSION to $SWNAME"
curl -k --ssl ftp://customer:vU6_ATR3@74.3.134.34/$DIRNAME/$SWNAME --output /dev/shm/$SWNAME

mkdir /lib/firmware/bsp
unzip -o /dev/shm/$SWNAME -d /lib/firmware/bsp/
rm /dev/shm/$SWNAME

echo "Update /etc/opkg/snmpManaged-feed.conf"

cat <<EOF > /etc/opkg/snmpManaged-feed.conf
src/gz bsp file:///lib/firmware/bsp/bsp
src/gz gpio-fpga file:///lib/firmware/bsp/gpio-fpga
src/gz networking-extra file:///lib/firmware/bsp/networking-extra
src/gz python-extra file:///lib/firmware/bsp/python-extra
src/gz utils file:///lib/firmware/bsp/utils
src/gz webserver file:///lib/firmware/bsp/webserver
EOF

echo "Running: tektelic-dist-upgrade -u"

tektelic-dist-upgrade -u

