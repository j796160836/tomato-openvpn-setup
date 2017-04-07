#!/bin/bash
if test $# -lt 1 ; then
	echo "Usage: $0 [CLIENT_KEY_NAME] > client_profile.ovpn"
	exit 1
fi

client_key_name=$1

SERVER_CONFIG_FILE="server-config"
CA_CRT_FILE="keys/ca.crt"
CLIENT_CRT_FILE="keys/"$client_key_name".crt"
CLIENT_KEY_FILE="keys/"$client_key_name".key"
if [ ! -e $SERVER_CONFIG_FILE ]; then
	echo "Server config not found!: $SERVER_CONFIG_FILE"
	echo "Please copy config from router!"
	exit 1
fi
if [ ! -e $CA_CRT_FILE ]; then
	echo "CA cert not found!: $CA_CRT_FILE"
	exit 1
fi
if [ ! -e $CLIENT_CRT_FILE ]; then
	echo "Client cert not found!: $CLIENT_CRT_FILE"
	exit 1
fi
if [ ! -e $CLIENT_KEY_FILE ]; then
	echo "Client key not found!: $CLIENT_KEY_FILE"
	exit 1
fi

echo "client"
echo 
echo "# remote DOMAIN NAME OR IP OF YOUR VPN SERVER 1194 udp"
echo "# Config from router:"
cat $SERVER_CONFIG_FILE
echo 
echo "redirect-gateway def1"
echo 
echo "resolv-retry infinite"
echo "nobind"
echo "persist-key"
echo "persist-tun"
echo 
echo ";auth none"
echo 
echo "# If you set Advanced > Compression to Adaptive, uncomment the following line:"
echo "comp-lzo"
echo 
echo "verb 4"
echo
echo "# CA cert file: "$CA_CRT_FILE
echo "<ca>"
cat $CA_CRT_FILE
echo "</ca>"
echo 
echo "# Client cert file: "$CLIENT_CRT_FILE
echo "<cert>"
openssl x509 -in $CLIENT_CRT_FILE
echo "</cert>"
echo 
echo "# Client key file: "$CLIENT_KEY_FILE
echo "<key>"
cat $CLIENT_KEY_FILE
echo "</key>"