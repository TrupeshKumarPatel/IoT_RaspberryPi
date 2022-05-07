#!/bin/bash
ifconfig wlan0 down
ifconfig eth0 down
killall wpa_supplicant
echo "

allow-hotplug wlan0
iface wlan0 inet manual
	wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
	
iface wlan0 inet dhcp

" >> /etc/network/interfaces
read -p 'Username(email-address): ' username
read -sp 'Password: ' password
echo "

network={
        ssid=\"eduroam\"
        key_mgmt=WPA-EAP
        eap=PEAP
        identity=\"$username\"
        password=\"$password\"
        phase2=\"auth=MSCHAPV2\"
}

" >> /etc/wpa_supplicant/wpa_supplicant.conf

echo ""
echo "Testing conntion with \"eduroam\""

timeout 20 wpa_supplicant -i wlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf > test_config_eduroam.txt

test=`grep "authentication completed successfully" test_config_eduroam.txt | wc -l`

if [ $test -ge 1 ]
then
	echo "\"eduroam\" Successfully connected!!!"
else
	echo "\"eduroam\" Conection Failed :("
fi

ifconfig wlan0 up
ifconfig eth0 up

/etc/init.d/dhcpcd restart

reboot
