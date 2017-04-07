#!/bin/bash
CA_CRT_FILE="keys/ca.crt"
SERVER_CRT_FILE="keys/SERVER.crt"
SERVER_KEY_FILE="keys/SERVER_nopass.key"
for file in keys/dh*.pem ; do DH_FILE=$file ; break 1 ; done

if [ ! -e $CA_CRT_FILE ]; then
	echo "CA cert not found!: $CA_CRT_FILE"
	exit 1
fi
if [ ! -e $SERVER_CRT_FILE ]; then
	echo "Server cert not found!: $SERVER_CRT_FILE"
	exit 1
fi
if [ ! -e $SERVER_KEY_FILE ]; then
	echo "Server key not found!: $SERVER_KEY_FILE"
	exit 1
fi
if [ ! -e $DH_FILE ]; then
	echo "Diffie Hellman file not found!: $DH_FILE"
	exit 1
fi

echo "================================================================"
echo "      Please paste it at Tomato's OpenVPN key config page"
echo "================================================================"
echo
echo "[Certificate Authority]"
echo
cat $CA_CRT_FILE
echo
echo "[Server Certificate]"
echo
openssl x509 -in $SERVER_CRT_FILE
echo
echo "[Server Key]"
echo
cat $SERVER_KEY_FILE
echo
echo "[Diffie Hellman parameters]"
echo
cat $DH_FILE
echo