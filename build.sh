#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

### Install packages
rpm-ostree override remove fedora-workstation-repositories firefox firefox-langpacks
rpm-ostree override remove toolbox --install distrobox
rpm-ostree install openresolv iwd
rpm-ostree install --idempotent /tmp/akmod-hp-wmi-0-0.10.x86_64.rpm /tmp/hp-wmi-0-0.10.x86_64.rpm /tmp/kmod-hp-wmi-0-0.10.x86_64.rpm
rpm-ostree install ffmpeg gstreamer1-plugin-libav gstreamer1-plugins-bad-free-extras gstreamer1-plugins-bad-freeworld gstreamer1-plugins-ugly gstreamer1-vaapi libva-nvidia-driver intel-media-driver libva-intel-driver
cp -r /tmp/NetworkManager/. /usr/lib/NetworkManager/
cp -r /tmp/modprobe.d/. /usr/lib/modprobe.d/
cp -r /tmp/lib/sysctl.d/. /usr/lib/sysctl.d/
cp /tmp/rpm-ostreed.conf /etc/rpm-ostreed.conf
systemctl enable iwd.service
systemctl disable wpa_supplicant.service
