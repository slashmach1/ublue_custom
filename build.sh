#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

### Set flatpak
flatpak remote-add --if-not-exists --system flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install --noninteractive --system flathub \
    app/com.github.tchx84.Flatseal/x86_64/stable \
    app/io.github.dvlv.boxbuddyrs/x86_64/stable \
    net.cozic.joplin_desktop \
    com.bitwarden.desktop \
    com.plexamp.Plexamp
### Install packages
rpm-ostree override remove fedora-workstation-repositories
rpm-ostree install distrobox openresolv iwd steam-devices steam
rpm-ostree install /tmp/hp-wmi-0-0.10.x86_64.rpm /tmp/kmod-hp-wmi-0-0.10.x86_64.rpm
echo "AutomaticUpdatePolicy=stage" | sudo tee --append /usr/etc/rpm-ostreed.conf
mkdir -p /usr/etc/NetworkManager/
cp -r /tmp/NetworkManager/. /usr/etc/NetworkManager/
mkdir -p /usr/etc/modprobe.d/
cp -r /tmp/modprobe.d/. /usr/etc/modprobe.d/
mkdir -p /usr/etc/lib/sysctl.d/
cp -r /lib/sysctl.d/. /usr/etc/lib/sysctl.d/
systemctl enable iwd.service
systemctl disable wpa_supplicant.service