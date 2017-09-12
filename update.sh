#!/bin/bash

FIRMWARE="firmware.bin"
IP="192.168.0.1"
while true; do
	T=$(($RANDOM + ($RANDOM % 2) * 32768))
	STATUS=`wget -t 1 --no-cache -T 0.2 -O - http://$IP/?_=$T 2>/dev/null`
	if [[ $STATUS == *"<title>Provided by D-Link</title>"* ]]; then
		echo "Uploading..."
		curl -F "data=@$FIRMWARE" --connect-timeout 99999 -m 99999 --output /dev/null http://$IP/f2.htm
		break
	elif [[ $STATUS == *"<title>D-LINK</title>"* ]]; then
		echo "Rebooting..."
		echo -n -e '\x00\x01\x00\x01EXEC REBOOT SYSTEMaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa' | timeout 1s nc -u $IP 19541
	fi
done