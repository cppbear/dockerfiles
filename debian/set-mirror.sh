#!/bin/bash

set -e

if [[ $UID -ne 0 ]]; then
    echo "Error: This script must be run as root."
    exit 1
fi

sed -i.bak '/http:\/\/deb\.debian\.org\/debian$/s||https://mirror.nju.edu.cn/debian|' /etc/apt/sources.list.d/debian.sources
apt update
