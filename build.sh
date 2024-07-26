#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

### Install packages
curl https://pkgs.tailscale.com/stable/fedora/tailscale.repo -o /etc/yum.repos.d/tailscale.repo
rpm-ostree override remove fedora-workstation-repositories firefox firefox-langpacks
rpm-ostree override remove toolbox --install distrobox
rpm-ostree install openresolv iwd android-tools ptyxis tailscale wireguard-tools
rpm-ostree install --idempotent /tmp/*xpadneo*.rpm /tmp/hp-wmi-0-0.10.x86_64.rpm /tmp/akmod-hp-wmi-0-0.10.x86_64.rpm 
cp -r /tmp/NetworkManager/. /usr/lib/NetworkManager/
cp -r /tmp/modprobe.d/. /usr/lib/modprobe.d/
cp -r /tmp/lib/sysctl.d/. /usr/lib/sysctl.d/
cp -r /tmp/share/. /usr/share/
cp -r /tmp/lib/systemd/. /usr/lib/systemd/
cp /tmp/rpm-ostreed.conf /etc/rpm-ostreed.conf
chmod go-w /usr/lib/systemd/system/*.*
systemctl enable dconf-update.service
systemctl enable flatpak-add-flathub-repo.service
systemctl enable flatpak-replace-fedora-apps.service
systemctl enable flatpak-cleanup.timer
systemctl enable rpm-ostreed-automatic.timer
systemctl disable wpa_supplicant.service
rm /etc/yum.repos.d/tailscale.repo
