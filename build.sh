#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

### Install packages
rpm-ostree override remove fedora-workstation-repositories firefox firefox-langpacks
rpm-ostree override remove toolbox --install distrobox
rpm-ostree install openresolv iwd
rpm-ostree install --idempotent /tmp/akmod-hp-wmi-0-0.10.x86_64.rpm /tmp/hp-wmi-0-0.10.x86_64.rpm /tmp/kmod-hp-wmi-0-0.10.x86_64.rpm /tmp/*xone*.rpm
cp -r /tmp/NetworkManager/. /usr/lib/NetworkManager/
cp -r /tmp/modprobe.d/. /usr/lib/modprobe.d/
cp -r /tmp/lib/sysctl.d/. /usr/lib/sysctl.d/
cp -r /tmp/lib/systemd/. /usr/lib/systemd/
cp /tmp/rpm-ostreed.conf /etc/rpm-ostreed.conf
chmod go-w /usr/lib/systemd/system/*.*
systemctl enable dconf-update.service
systemctl enable flatpak-add-flathub-repo.service
systemctl enable flatpak-replace-fedora-apps.service
systemctl enable flatpak-cleanup.timer
systemctl enable rpm-ostreed-automatic.timer
systemctl enable iwd.service
systemctl disable wpa_supplicant.service
