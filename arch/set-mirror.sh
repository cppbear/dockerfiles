#!/bin/bash

set -e

if [[ $UID -ne 0 ]]; then
    echo "Error: This script must be run as root."
    exit 1
fi

mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak && \
&& echo 'Server = https://mirror.nju.edu.cn/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist \
&& echo '[archlinuxcn]' >> /etc/pacman.conf \
&& echo 'Server = https://mirror.nju.edu.cn/archlinuxcn/$arch' >> /etc/pacman.conf \
&& pacman -Syu --noconfirm archlinuxcn-keyring && pacman-key --populate archlinuxcn \
&& pacman -Syu --noconfirm --needed paru \
&& sed -i 's/^#BottomUp/BottomUp/' /etc/paru.conf
