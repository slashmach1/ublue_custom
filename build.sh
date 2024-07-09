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
# Setup repo
cat << EOF > /etc/yum.repos.d/google-chrome.repo
[google-chrome]
name=google-chrome
baseurl=https://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-google
EOF

# Import signing key
curl --retry 3 --retry-delay 2 --retry-all-errors -sL \
  -o /etc/pki/rpm-gpg/RPM-GPG-KEY-google \
  https://dl.google.com/linux/linux_signing_key.pub
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-google

# Now let's install the packages.
rpm-ostree install google-chrome-stable

# Clean up the yum repo (updates are baked into new images)
rm /etc/yum.repos.d/google-chrome.repo -f
rpm-ostree override remove firefox firefox-langpacks  
rpm-ostree install ffmpeg gstreamer1-plugin-libav gstreamer1-plugins-bad-free-extras gstreamer1-plugins-bad-freeworld gstreamer1-plugins-ugly gstreamer1-vaapi 
rpm-ostree override remove fedora-workstation-repositories
rpm-ostree install distrobox openresolv iwd steam-devices steam libva-nvidia-driver intel-media-driver libva-intel-driver
rpm-ostree install --idempotent /tmp/akmod-hp-wmi-0-0.10.x86_64.rpm /tmp/hp-wmi-0-0.10.x86_64.rpm /tmp/kmod-hp-wmi-0-0.10.x86_64.rpm
cp -r /tmp/NetworkManager/. /etc/NetworkManager/
cp -r /tmp/modprobe.d/. /etc/modprobe.d/
cp -r /tmp/lib/sysctl.d/. /etc/sysctl.d/
systemctl enable iwd.service
systemctl disable wpa_supplicant.service