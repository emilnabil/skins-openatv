#!/bin/sh

#wget -q "--no-check-certificate" https://raw.githubusercontent.com/emil237/skins-openatv/main/skins-bluemetalfhd.sh  -O - | /bin/sh
VERSION=2.08a
VERSIONS=2.10
PLUGIN_PATH='/usr/share/enigma2/BlueMetalFHD'
PYTHON_VERSION=$(python -c"import platform; print(platform.python_version())")

if [ -f /etc/apt/apt.conf ] ; then
    STATUS='/var/lib/dpkg/status'
    OS='DreamOS'
elif [ -f /etc/opkg/opkg.conf ] ; then
   STATUS='/var/lib/opkg/status'
   OS='Opensource'
fi


# Remove old version #

if [ -d $PLUGIN_PATH ]; then

   rm -rf $PLUGIN_PATH
  
fi

if [ "$PYTHON_VERSION" == 3.9.9 -o "$PYTHON_VERSION" == 3.9.7 ]; then
    echo ":You have $PYTHON_VERSION image ..."
    PYTHON='PY3'
    IMAGING='python3-imaging'
    PYSIX='python3-six'
elif [ "$PYTHON_VERSION" == 3.10.4 ]; then
    echo ":You have $PYTHON_VERSION image ..."
    PYTHONLAST='PY3'
    IMAGING='python3-imaging'
    PYSIX='python3-six'    
else
    echo ":You have $PYTHON_VERSION image ..."
    PYTHON='PY2'
    IMAGING='python-imaging'
    PYSIX='python-six'
fi

# if python --version 2>&1 | grep -q '^Python 3\.'; then
#    echo "You have Python3 image"
#    PYTHON='PY3'
#    IMAGING='python3-imaging'
#    PYSIX='python3-six'
# else
#    echo "You have Python2 image"
#    PYTHON='PY2'
#    IMAGING='python-imaging'
#    PYSIX='python-six'
# fi

if grep -q $IMAGING $STATUS; then
    imaging='Installed'
fi

if grep -q $PYSIX $STATUS; then
    six='Installed'
fi

if [ $imaging = "Installed" -a $six = "Installed" ]; then
     echo "All dependecies are installed"
else

    if [ $OS = "Opensource" ]; then
        echo "=========================================================================="
        echo "Some Depends Need to Be downloaded From Feeds ...."
        echo "=========================================================================="
        echo "Opkg Update ..."
        echo "========================================================================"
        opkg update
        echo "========================================================================"
        echo " Downloading $IMAGING , $PYSIX ......"
        opkg install $IMAGING
        echo "========================================================================"
        opkg install $PYSIX
        echo "========================================================================"
    else
        echo "=========================================================================="
        echo "Some Depends Need to Be downloaded From Feeds ...."
        echo "=========================================================================="
        echo "apt Update ..."
        echo "========================================================================"
        apt-get update
        echo "========================================================================"
        echo " Downloading $IMAGING , $PYSIX ......"
        apt-get install $IMAGING -y
        echo "========================================================================"
        apt-get install $PYSIX -y
        echo "========================================================================"
    fi


fi

if grep -q $IMAGING $STATUS; then
    echo ""
else
    echo "#########################################################"
    echo "#       $IMAGING Not found in feed                      #"
    echo "#########################################################"
fi

if grep -q $PYSIX $STATUS; then
    echo ""
else
    echo "#########################################################"
    echo "#       $PYSIX Not found in feed                        #"
    echo "#########################################################"
    exit 1
fi

CHECK='/tmp/check'
uname -m > $CHECK
sleep 1;

    if [ "$PYTHONLAST" = "PY3" ]; then
        wget -q  "--no-check-certificate" https://raw.githubusercontent.com/emil237/skins-openatv/main/skins-bluemetalfhd_$VERSIONS_all.ipk -O /tmp/skins-bluemetalfhd_2.10_all.ipk
  opkg install --force-overwrite /tmp/skins-bluemetalfhd_2.10_all.ipk
        rm -f /tmp/skins-bluemetalfhd_2.10_all.ipk
    else
        wget -q  "--no-check-certificate" https://raw.githubusercontent.com/emil237/skins-openatv/main/skins-bluemetalfhd_$VERSION_all.ipk -O /tmp/skins-bluemetalfhd_2.08a_all.ipk
        opkg install --force-overwrite /tmp/skins-bluemetalfhd_2.08a_all.ipk
        rm -f /tmp/skins-bluemetalfhd_2.08a_all.ipk
         
    elif grep -qs -i 'armv7l' cat $CHECK ; then
    echo "[ Your device is armv7l ]"
    if [ "$PYTHON" = "PY3" ]; then
        wget -q  "--no-check-certificate" https://raw.githubusercontent.com/emil237/skins-openatv/main/skins-bluemetalfhd_$VERSION_all.ipk -O /tmp/skins-bluemetalfhd_2.08a_all.ipk
        opkg install --force-overwrite /tmp/skins-bluemetalfhd_2.08a_all.ipk
        rm -f /tmp/skins-bluemetalfhd_2.08a_all.ipk
    
    fi
##
if [ "$VERSION" = "2.08a" ]; then
    echo ""
    echo "#########################################################"
    echo "#     skin-bluemetal-fhd $VERSION INSTALLED SUCCESSFULLY          #"
    echo "#                    BY Emil_Nabil                        #"
    echo "#########################################################"
    echo "#                Restart Enigma2 GUI                    #"
    echo "#########################################################"
else
    echo ""
    echo "#########################################################"
    echo "#     skin-bluemetal-fhd $VERSIONS INSTALLED SUCCESSFULLY         #"
    echo "#                    BY Emil_Nabil                        #"
    echo "#########################################################"
    echo "#                Restart Enigma2 GUI                    #"
    echo "#########################################################"
fi        
sleep 2
if [ $OS = 'DreamOS' ]; then
    systemctl restart enigma2
else
    killall -9 enigma2
fi
exit 0











