#!/bin/bash
. vars &> /dev/null
export KEY_CN=$KEY_NAME
./clean-all
./build-dh
echo -en "\n\n\n\n\n\n\n\n" | ./build-ca
./build-key-server --batch SERVER
openssl rsa -in keys/SERVER.key -out keys/SERVER_nopass.key
./print-server-keys.sh

#echo -en "\n\n\n\n\n\n\n\npass\n\ny\n" | ./build-key-server SERVER
