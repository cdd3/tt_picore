# tt_picore

Work in progress DO NOT USE THIS YET!

The intent is to create a shell script to configure software for the terminal tedium on picore linux


Get [Pi Core](http://tinycorelinux.net/9.x/armv6/releases/RPi/)

Helpful instructions on how to write an image to your SD card [here](https://www.raspberrypi.org/documentation/installation/installing-images/README.md) if you need help

Do this part with the pi connected to a monitor & keyboard or via ssh.  Either way unless / until you setup the wireless you will need a wired ethernet connection available for the pi.

Boot the pi with the SD card you just made
[Expand the partition and resize the filesystem](https://iotbytes.wordpress.com/picore-tiny-core-linux-on-raspberry-pi/)

I like to [Setup Wireless](https://iotbytes.wordpress.com/make-raspberry-pi-3-built-in-wifi-module-work-with-picore/) right away but you don't have to bother with this step if it's not important to you.  The WIFI on the pi doesn't seem to have much range once it's inside my eurorack case.

Do the following:

tce-load -iw wget

wget https://raw.githubusercontent.com/cdd3/tt_picore_setup/master/install.sh

chmod +x install.sh

./install.sh
