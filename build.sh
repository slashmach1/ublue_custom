#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"


### Install packages
rpm-ostree override remove \
    firefox \
    firefox-langpacks \
    fedora-workstation-repositories
    
rpm-ostree override remove libavcodec-free \
libavfilter-free \
libavformat-free \
libavutil-free \
libpostproc-free \ 
libswresample-free \ 
libswscale-free \
--install ffmpeg
                           
rpm-ostree override remove wpa_supplicant \
--install iwd
                           
rpm-ostree install distrobox \
gstreamer1-plugin-libav \
gstreamer1-plugins-bad-free-extras \
gstreamer1-plugins-bad-freeworld \
gstreamer1-plugins-ugly \
gstreamer1-vaapi \
intel-media-driver \
libva-intel-driver \
libva-nvidia-driver \
openresolv

rpm-ostree install https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
rpm-ostree install /tmp/akmod-hp-wmi-0-0.10.x86_64.rpm /tmp/hp-wmi-0-0.10.x86_64.rpm /tmp/kmod-hp-wmi-0-0.10.x86_64.rpm
echo "AutomaticUpdatePolicy=stage" | sudo tee --append /etc/rpm-ostreed.conf
cp -r /tmp/NetworkManager/. /etc/NetworkManager/
systemctl enable iwd
