#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

# Prepare staging directory
mkdir -p /var/opt # -p just in case it exists

# Prepare alternatives directory
mkdir -p /var/lib/alternatives
cat << EOF > /etc/yum.repos.d/google-chrome.repo
[google-chrome]
name=google-chrome
baseurl=https://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-google
EOF
curl --retry 3 --retry-delay 2 --retry-all-errors -sL \
  -o /etc/pki/rpm-gpg/RPM-GPG-KEY-google \
  https://dl.google.com/linux/linux_signing_key.pub
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-google

## package installs
rpm-ostree install distrobox openresolv iwd android-tools wireguard-tools steam-devices google-chrome-stable ffmpeg gstreamer1-plugin-libav gstreamer1-plugins-bad-free-extras gstreamer1-plugins-bad-freeworld gstreamer1-plugins-ugly gstreamer1-vaapi libva-nvidia-driver intel-media-driver libva-intel-driver 
## overrides
rpm-ostree override remove fedora-workstation-repositories firefox firefox-langpacks
## cleanup
rm /etc/yum.repos.d/google-chrome.repo -f

##chrome post setup
mv /var/opt/google /usr/lib/google # move this over here
#####
# Register path symlink
# We do this via tmpfiles.d so that it is created by the live system.
cat >/usr/lib/tmpfiles.d/google.conf <<EOF
L  /opt/google  -  -  -  -  /usr/lib/google
EOF
