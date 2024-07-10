#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

### Install packages
rpm-ostree override remove fedora-workstation-repositories firefox firefox-langpacks
rpm-ostree install distrobox openresolv iwd steam-devices steam gamescope
### Install chrome
cat << EOF > /etc/yum.repos.d/google-chrome.repo
[google-chrome]
name=google-chrome
baseurl=https://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=0
gpgkey=https://dl.google.com/linux/linux_signing_key.pub
EOF
rpm-ostree install google-chrome-stable
rpm-ostree install ffmpeg gstreamer1-plugin-libav gstreamer1-plugins-bad-free-extras gstreamer1-plugins-bad-freeworld gstreamer1-plugins-ugly gstreamer1-vaapi libva-nvidia-driver intel-media-driver libva-intel-driver
# Clean up the yum repo (updates are baked into new images)
rm /etc/yum.repos.d/google-chrome.repo -f
rpm-ostree install --idempotent /tmp/akmod-hp-wmi-0-0.10.x86_64.rpm /tmp/hp-wmi-0-0.10.x86_64.rpm /tmp/kmod-hp-wmi-0-0.10.x86_64.rpm
cp -r /tmp/NetworkManager/. /usr/lib/NetworkManager/
cp -r /tmp/modprobe.d/. /usr/lib/modprobe.d/
cp -r /tmp/lib/sysctl.d/. /usr/lib/sysctl.d/
systemctl enable iwd.service
systemctl disable wpa_supplicant.service
flatpak remote-add --if-not-exists --system flathub https://flathub.org/repo/flathub.flatpakrepo