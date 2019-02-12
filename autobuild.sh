#!/bin/bash

# gpg --detach-sign Ctlos.iso

USER="tank"
iso_name=archlinux

chmod +x ./autobuild.sh ./build.sh ./mkarchiso.sh airootfs/root/customize_airootfs.sh
chmod -R +755  ./
rm -rf ./work ./out

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

ISO="${iso_name}-$iso_de${iso_version}.iso"

#Build ISO File
package=archiso
if pacman -Qs $package > /dev/null ; then
    echo "The package $package is installed"
else
    echo "Installing package $package"
    pacman -S $package --noconfirm
fi

source build.sh -v

chown $USER out/

#rm -rf work