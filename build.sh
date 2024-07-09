#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"


### Install packages
rpm-ostree override remove firefox firefox-langpacks fedora-workstation-repositories wpa_supplicant--install iwd                           
rpm-ostree install distrobox openresolv
rpm-ostree install https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
rpm-ostree install /tmp/akmod-hp-wmi-0-0.10.x86_64.rpm /tmp/hp-wmi-0-0.10.x86_64.rpm /tmp/kmod-hp-wmi-0-0.10.x86_64.rpm
echo "AutomaticUpdatePolicy=stage" | sudo tee --append /etc/rpm-ostreed.conf
cp -r /tmp/NetworkManager/. /etc/NetworkManager/
systemctl enable iwd
