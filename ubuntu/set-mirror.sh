#!/bin/bash

set -e

if [[ $UID -ne 0 ]]; then
    echo "Error: This script must be run as root."
    exit 1
fi

ARCH=$(uname -m)

if [[ $ARCH == "x86_64" ]]; then
    echo "Target architecture: $ARCH"
    sed -i.bak 's|http://archive.ubuntu.com/ubuntu|https://mirror.nju.edu.cn/ubuntu|g' /etc/apt/sources.list.d/ubuntu.sources
elif [[ $ARCH == "aarch64" || $ARCH == "armv7l" ]]; then
    echo "Target architecture: $ARCH"
    sed -i.bak '0,/http:\/\/ports.ubuntu.com\/ubuntu-ports/s||https://mirror.nju.edu.cn/ubuntu-ports|' /etc/apt/sources.list.d/ubuntu.sources
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi
apt update
