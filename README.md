# Tomato's OpenVPN settings

- Tomato Firmware: v3.4-138 AIO  
- OpenVPN version: v2.3.11

## Steps

1. Download `easy-rsa` v2  
https://github.com/OpenVPN/easy-rsa/releases/tag/2.2.2

2. Copy these scripts to the same folder

3. Edit `vars` file

```
$ vi vars
```

edit these parameters

```
export KEY_SIZE=2048

export KEY_COUNTRY="US"
export KEY_PROVINCE="CA"
export KEY_CITY="SanFrancisco"
export KEY_ORG="Fort-Funston"
export KEY_EMAIL="me@myhost.mydomain"
export KEY_OU="MyOrganizationalUnit"

export KEY_NAME="EasyRSA"

export KEY_CN="CommonName"
```

4. Setup server keys

Run `generate-keys-server.sh` scripts
```
$ ./generate-keys-server.sh
```
Warning: That will clean all the keys
That will generate ca cert, server keys...etc.
It will show up a screen like this when it done.

![1](https://raw.githubusercontent.com/j796160836/tomato-openvpn-setup/master/screenshots/paste_key.png)

```
================================================================
      Please paste it at Tomato's OpenVPN key config page
================================================================

[Certificate Authority]

-----BEGIN CERTIFICATE-----
MIIDhDCCAu2gAwIBAgIJAJ9a8dYhq73TMA0GCSqGSIb3DQEBCwUAMIGJMQswCQYD
Q6Xp2vd6068LHC7b9qTs1nWHfYbpdOv1GmzKONIGd3FDiuRFJu4J/g==
-----END CERTIFICATE-----

[Server Certificate]

-----BEGIN CERTIFICATE-----
MIID5jCCA0+gAwIBAgIBATANBgkqhkiG9w0BAQsFADCBiTELMAkGA1UEBhMCVFcx
TRmjwzCO84lz2LOYFDVlETjb6Mb76SysoHVb4zNPX7Bkrr2u3c8+vzaV
-----END CERTIFICATE-----

[Server Key]

-----BEGIN RSA PRIVATE KEY-----
MIICXAIBAAKBgQCy1Pwvi8bE0dTpNddzNBluQoKHdHQpa7mBuH7T0+fWLhs3HoEd
POvdTEVwh+G/2kce8xtOwJAkvyppXMWjY2WmSqimVP8=
-----END RSA PRIVATE KEY-----

[Diffie Hellman parameters]

-----BEGIN DH PARAMETERS-----
MIGHAoGBAN8PIYvlZy1rDghoF+K9wmMrCaN5DBi+3HPFemJEZK4wlyeXHLDOGYx+
5vtwBR2tPYXwTwdeMZItmqVMsVuIN4d0vEzDrbNihAU7OaaWzP+bAgEC
-----END DH PARAMETERS-----
```

(Please run by your self, don't copy the key provide in there)

Paste it at OpenVPN key config page
If you lost these key, run again this script to print again
```
$ ./print-server.sh
```

5. Fetch config from Tomato router
Run script on your Tomato router
Copy all the `fetch-server-config.txt` content into router's run command screens.

![2](https://raw.githubusercontent.com/j796160836/tomato-openvpn-setup/master/screenshots/fetch_config1.png)

```
#!/bin/bash
server_config="/etc/openvpn/server1/config.ovpn"
if [ ! -e $server_config ]; then
    echo "File not found!: $server_config"
    exit 1
fi
port=`cat $server_config | grep "port" | awk '{print $2}'`
public_ip=`curl -s ipinfo.io/ip`
#public_ip=`curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//'`

config_data="remote "$public_ip" "$port"\n"$(cat $server_config | grep "proto\|dev\|cipher" | awk '{printf "%s\\n", $0}')

echo "=================================================="
echo "Please paste this command in your easy-rsa folder"
echo "=================================================="
echo
echo "echo -e \""$config_data"\" > server-config" 
```

you will get something like this  

![3](https://raw.githubusercontent.com/j796160836/tomato-openvpn-setup/master/screenshots/fetch_config2.png)

```
================================================== 
Please paste this command in your easy-rsa folder 
================================================== 
 
echo -e "remote 1.2.3.4 1194\nproto udp\ndev tun21\ncipher DES-CBC\n" > server-config 
```
run what your got in your command line

6. Generate client keys

Run `generate-keys-client.sh` scripts
```
$ ./generate-keys-client.sh Client01
```

you will see this success message
```
Write out database with 1 new entries
Data Base Updated
```

7. Generate config file
print configuration and save it
```
$ ./print-client-config.sh Client01 > Client01.ovpn
```

