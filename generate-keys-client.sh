#!/bin/bash
if test $# -lt 1 ; then
	echo "Usage: $0 [CLIENT_NAME]"
	exit 1
fi

. vars &> /dev/null
export KEY_CN=$1
./build-key --batch $1