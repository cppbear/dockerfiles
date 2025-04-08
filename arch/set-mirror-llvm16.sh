#!/bin/bash

set -e

if [[ $UID -ne 0 ]]; then
    echo "Error: This script must be run as root."
    exit 1
fi

echo 'Server = https://arch-archive.tuna.tsinghua.edu.cn/2024/03-04/$repo/os/$arch' > /etc/pacman.d/mirrorlist
pacman -Syy
