#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"


### Install packages
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
rpm-ostree override remove fedora-workstation-repositories firefox firefox-langpacks  
rpm-ostree install distrobox openresolv iwd steam-devices
rpm-ostree install /tmp/akmod-hp-wmi-0-0.10.x86_64.rpm /tmp/hp-wmi-0-0.10.x86_64.rpm /tmp/kmod-hp-wmi-0-0.10.x86_64.rpm
echo "AutomaticUpdatePolicy=stage" | sudo tee --append /etc/rpm-ostreed.conf
cp -r /tmp/NetworkManager/. /etc/NetworkManager/
cp -r /tmp/modprobe.d/. /etc/modprobe.d/
systemctl enable iwd.service
systemctl disable wpa_supplicant.service