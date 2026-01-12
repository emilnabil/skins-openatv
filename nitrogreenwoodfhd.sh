#!/bin/bash
##setup command=wget https://github.com/emilnabil/skins-openatv/raw/refs/heads/main/nitrogreenwoodfhd.sh -O - | /bin/sh
########################################
echo "Removing previous version ..."
sleep 2

# Check if the directory exists before removing it
if [ -d /usr/share/enigma2/NitroGreenWoodFHD ]; then
    rm -rf /usr/share/enigma2/NitroGreenWoodFHD > /dev/null 2>&1
    echo 'Package removed.'
else
    echo "You do not have previous version"
fi

echo ""
opkg install enigma2-plugin-extensions-bitrate enigma2-plugin-extensions-oaweather
opkg install curl
sleep 2

# Download and extract the package
cd /tmp || exit
curl -k -Lbk -m 55532 -m 555104 "https://github.com/emilnabil/skins-openatv/raw/refs/heads/main/NitroGreenWoodFHD.tar.gz" -o /tmp/NitroGreenWoodFHD.tar.gz
sleep 1
echo "Installing ...."
tar -xzf /tmp/NitroGreenWoodFHD.tar.gz -C /
echo ""
echo ""
sleep 1
rm -f /tmp/NitroGreenWoodFHD.tar.gz
sleep 2
exit 0


