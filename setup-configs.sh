#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"
## file and service changes
cp -r /tmp/NetworkManager/. /usr/lib/NetworkManager/
cp -r /tmp/modprobe.d/. /usr/lib/modprobe.d/
cp -r /tmp/lib/sysctl.d/. /usr/lib/sysctl.d/
cp -r /tmp/lib/systemd/. /usr/lib/systemd/
cp -r /tmp/share/. /usr/share/
cp /tmp/rpm-ostreed.conf /etc/rpm-ostreed.conf
chmod go-w /usr/lib/systemd/system/*.*
systemctl enable dconf-update.service
systemctl enable flatpak-add-flathub-repo.service
systemctl enable flatpak-replace-fedora-apps.service
systemctl enable flatpak-cleanup.timer
systemctl enable rpm-ostreed-automatic.timer
systemctl disable wpa_supplicant.service