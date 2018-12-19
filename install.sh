#!/bin/sh

echo ""
echo ""
echo ""
echo ">>>>> terminal tedium <<<<<< -----------------------------------------------"
echo ""
echo "(sit back, this will take a 2-3 minutes)"
echo ""

PD_VERSION="pd-0.47-1"

HARDWARE_VERSION=$(uname -m)

if [[ "$HARDWARE_VERSION" == 'armv6l' ]]; then
		echo "--> using armv6l (A+, zero)"
elif [[ "$HARDWARE_VERSION" == 'armv7l' ]]; then
		echo "--> using armv7l (pi2, pi3)"
else
	echo "not using pi ?... exiting"
	exit -1
fi
echo ""
echo "installing required packages ... -------------------------------------------"
echo ""
tce-load -iw git
tce-load -iw make
tce-load -iw gcc
tce-load -iw compiletc
tce-load -iw wget
tce-load -iw tar
tce-load -iw acl
tce-load -iw wiringpi
tce-load -iw wiringpi-dev
tce-load -iw libunistring
tce-load -iw alsa
tce-load -iw alsa-utils
#tce-load -iw wireless_tools
#tce-load -iw wpa_supplicant
tce-load -iw firmware-rpi3-wireless
tce-load -iw wifi

echo ""

echo "cloning terminal tedium repo ... -------------------------------------------"
echo ""
cd $HOME 
rm -r -f $HOME/terminal_tedium >/dev/null 2>&1
git clone https://github.com/mxmxmx/terminal_tedium
cd $HOME/terminal_tedium
#git pull origin

echo ""

#echo "installing wiringPi ... -------------------------------------------------------"
#echo ""
#cd $HOME 
#git clone git://git.drogon.net/wiringPi
#cd wiringPi 
#git pull origin 
#./build >/dev/null 2>&1
#rm -r -f /home/pi/wiringPi

#echo ""
#echo ""

echo "installing pd ($PD_VERSION)... ---------------------------------------------"
echo ""
cd $HOME
wget http://msp.ucsd.edu/Software/$PD_VERSION.armv7.tar.gz
tar -zxf $PD_VERSION.armv7.tar.gz >/dev/null
rm $PD_VERSION.armv7.tar.gz

echo ""

echo "installing externals ... ---------------------------------------------------"
echo ""
#cd $HOME/terminal_tedium/software/externals/

echo " > terminal_tedium_adc"
#gcc -std=c99 -O3 -Wall -c terminal_tedium_adc.c -o terminal_tedium_adc.o
#ld --export-dynamic -shared -o terminal_tedium_adc.pd_linux terminal_tedium_adc.o  -lc -lm -lwiringPi
#sudo mv terminal_tedium_adc.pd_linux /home/pi/$PD_VERSION/extra/
cp $HOME/terminal_tedium/software/externals/terminal_tedium_adc.pd_linux $HOME/$PD_VERSION/extra/

echo " > tedium_input"
#gcc -std=c99 -O3 -Wall -c tedium_input.c -o tedium_input.o
#ld --export-dynamic -shared -o tedium_input.pd_linux tedium_input.o  -lc -lm -lwiringPi
#sudo mv tedium_input.pd_linux /home/pi/$PD_VERSION/extra/
cp $HOME/terminal_tedium/software/externals/tedium_input.pd_linux $HOME/$PD_VERSION/extra/

echo " > tedium_output"
#gcc -std=c99 -O3 -Wall -c tedium_output.c -o tedium_output.o
#ld --export-dynamic -shared -o tedium_output.pd_linux tedium_output.o  -lc -lm -lwiringPi
#sudo mv tedium_output.pd_linux /home/pi/$PD_VERSION/extra/
cp $HOME/terminal_tedium/software/externals/tedium_output.pd_linux $HOME/$PD_VERSION/extra/


echo " > tedium_switch"
#gcc -std=c99 -O3 -Wall -c tedium_switch.c -o tedium_switch.o
#ld --export-dynamic -shared -o tedium_switch.pd_linux tedium_switch.o  -lc -lm -lwiringPi
#sudo mv tedium_switch.pd_linux /home/pi/$PD_VERSION/extra/
cp $HOME/terminal_tedium/software/externals/tedium_switch.pd_linux $HOME/$PD_VERSION/extra/

#rm terminal_tedium_adc.o
#rm tedium_input.o
#rm tedium_output.o
#rm tedium_switch.o

#echo " > abl_link~"
#cd $HOME/terminal_tedium/software/externals/abl_link/
#sudo mv abl_link~.pd_linux $HOME/$PD_VERSION/extra/

echo ""

# create aliases

cd $HOME

rm -f .bash_aliases >/dev/null
echo -n > .bash_aliases

echo "alias sudo='sudo '" >> .bash_aliases
echo "alias puredata='$HOME/$PD_VERSION/bin/pd'" >> .bash_aliases
echo "alias pd='$HOME/$PD_VERSION/bin/pd'" >> .bash_aliases

echo "done installing pd ... -----------------------------------------------------"

echo ""
echo ""

echo "rc.local ... ---------------------------------------------------------------"
#change target to call rt_start from (append to) /opt/bootlocal.sh
sudo cp $HOME/terminal_tedium/software/rc.local /etc/rc.local

if [[ "$HARDWARE_VERSION" == 'armv6l' ]]; then
	sudo cp $HOME/terminal_tedium/software/rt_start_armv6 $HOME/terminal_tedium/software/rt_start
else
	sudo cp $HOME/terminal_tedium/software/rt_start_armv7 $HOME/terminal_tedium/software/rt_start
fi

sudo chmod +x /etc/rc.local
sudo chmod +x $HOME/terminal_tedium/software/rt_start

sudo echo '/etc/rc.local' >> /opt/.filetool.lst

echo ""
echo ""

echo "boot/config ... ------------------------------------------------------------"

#sudo cp /home/pi/terminal_tedium/software/config.txt /boot/config.txt 
mount /dev/mmcblk0p1
sudo echo '

gpu_mem=16
dtparam=i2c_arm=on
dtparam=spi=on
dtparam=i2s=on
device_tree_overlay=i2s-mmap
### wm8731:
device_tree_overlay=rpi-proto' >> /mnt/mmcblk0p1

echo ""
echo ""

#echo "alsa ... ------------------------------------------------------------------"

sudo cp $HOME/terminal_tedium/software/asound.conf /etc/asound.conf

sudo echo '/etc/asound.conf' >> /opt.filetool.lst

#echo ""
#echo ""

#sudo apt-get --assume-yes install alsa-utils

#echo ""
#echo ""

echo "done ... cleaning up -------------------------------------------------------"

# remove hardware files and other stuff that's not needed
cd $HOME/terminal_tedium/software/
rm -r externals
rm asound.conf
rm pdpd
rm pullup.py
rm rc.local
rm rt_start_armv*
rm config.txt
rm install.sh
cd $HOME/terminal_tedium/
rm -rf hardware
rm *.md
cd $HOME
rm install.sh

echo "Saving System State  -------------------------------------------------------"
filetool.sh -b

echo "Rebooting System     -------------------------------------------------------"
sudo reboot
echo ""
