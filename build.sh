#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"


### Install packages
rpm-ostree override remove \
    firefox \
    firefox-langpacks \
    fedora-workstation-repositories
rpm-ostree override remove libavcodec-free \
                           libavfilter-free libavformat-free \
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
cat <<EOF | tee /etc/NetworkManager/conf.d/wifi_backend.conf
[device]
wifi.backend=iwd
EOF

cat <<EOF | tee /etc/NetworkManager/conf.d/dns.conf
[main]
dns=dnsmasq
EOF

cat <<EOF | tee /etc/NetworkManager/dnsmasq.d/ipv6-listen.conf
listen-address=::1
EOF

cat <<EOF | tee /etc/NetworkManager/dnsmasq.d/cache.conf
cache-size=1000
EOF

cat <<-EOF | tee /etc/NetworkManager/conf.d/rc-manager.conf
[main]
rc-manager=resolvconf
EOF

rpm-ostree install https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
rpm-ostree install /rpms/*.rpm
echo "AutomaticUpdatePolicy=stage" | sudo tee --append /etc/rpm-ostreed.conf
systemctl enable iwd
