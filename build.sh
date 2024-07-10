#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

### Install packages
rpm-ostree override remove fedora-workstation-repositories firefox firefox-langpacks
rpm-ostree install distrobox openresolv iwd steam-devices
rpm-ostree install --idempotent /tmp/akmod-hp-wmi-0-0.10.x86_64.rpm /tmp/hp-wmi-0-0.10.x86_64.rpm /tmp/kmod-hp-wmi-0-0.10.x86_64.rpm
cp -r /tmp/NetworkManager/. /etc/NetworkManager/
cp -r /tmp/modprobe.d/. /etc/modprobe.d/
cp -r /tmp/lib/sysctl.d/. /etc/sysctl.d/
systemctl enable iwd.service
systemctl disable wpa_supplicant.service