#!/bin/bash

set -e

if [[ $UID -ne 0 ]]; then
    echo "Error: This script must be run as root."
    exit 1
fi

sed -e 's|^metalink=|#metalink=|g' \
    -e 's|^#baseurl=http://download.example/pub/fedora/linux|baseurl=https://mirror.nju.edu.cn/fedora|g' \
    -i.bak \
    /etc/yum.repos.d/fedora.repo \
    /etc/yum.repos.d/fedora-updates.repo
dnf makecache
