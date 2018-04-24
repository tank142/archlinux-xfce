#!/bin/bash

USER="liveuser"

set -e -u

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
sed -i "s/#\(ru_RU\.UTF-8\)/\1/" /etc/locale.gen
locale-gen

ln -sf /usr/share/zoneinfo/UTC /etc/localtime
hwclock --systohc --utc

usermod -s /usr/bin/bash root
cp -aT /etc/skel/ /root/
chmod 700 /root

sed -i 's/#\(PermitRootLogin \).\+/\1yes/' /etc/ssh/sshd_config
#sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

sed -i 's/#\(HandleSuspendKey=\)suspend/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleLidSwitch=\)suspend/\1ignore/' /etc/systemd/logind.conf

#systemctl enable pacman-init.service choose-mirror.service
pacman-key --init
pacman-key --populate archlinux
systemctl set-default multi-user.target
systemctl enable NetworkManager.service
#systemctl enable lightdm.service
systemctl enable lxdm.service
systemctl set-default graphical.target
systemctl disable dhcpcd@
#add missing /media directory
mkdir -p /media
chmod 755 -R /media

#fix permissions
chown root:root /
chown root:root /etc
chown root:root /etc/default
chown root:root /usr
chmod 755 /etc

#enable sudo
chmod 750 /etc/sudoers.d
chmod 440 /etc/sudoers.d/g_wheel
chown -R root /etc/sudoers.d
chmod -R 755 /etc/sudoers.d
echo "QT_QPA_PLATFORMTHEME=qt5ct" >> /etc/environment

# add liveuser
groupadd -r autologin
groupadd -r nopasswdlogin
id -u $USER &>/dev/null || useradd -m $USER -g users -G "adm,audio,floppy,log,network,rfkill,scanner,storage,optical,autologin,nopasswdlogin,power,wheel" -s /bin/bash
passwd -d $USER
echo "user ALL=(ALL) ALL" >> /etc/sudoers
echo 'Live User Created'

mv /root/mirrorlist /etc/pacman.d/mirrorlist
mv /root/xfce4.tar /home/$USER/
chmod +777 /home/$USER/xfce4.tar
su $USER -c "mkdir -p /home/$USER/.config"
su $USER -c "tar -xvf /home/$USER/xfce4.tar -C /home/$USER/.config/"
rm /home/$USER/xfce4.tar

su $USER -c "mkdir -p /home/$USER/.icons/default"
su $USER -c "echo '[Icon Theme]
Name=Default
Comment=Default Cursor Theme
Inherits=Oxygen_Black' > /home/$USER/.icons/default/index.theme"

mkdir -p /etc/skel/.icons/default
echo '[Icon Theme]
Name=Default
Comment=Default Cursor Theme
Inherits=Oxygen_Black' > /etc/skel/.icons/default/index.theme