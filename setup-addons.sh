#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"
##setup repos
curl https://pkgs.tailscale.com/stable/fedora/tailscale.repo -o /etc/yum.repos.d/tailscale.repo
sed -i 's/enabled=1/enabled=0/' /etc/yum.repos.d/*updates-*.repo
rpm-ostree install --idempotent wireguard-tools tailscale distrobox openresolv iwd android-tools steam-devices /tmp/*.rpm
sed -i 's/enabled=0/enabled=1/' /etc/yum.repos.d/*updates-*.repo
rm /etc/yum.repos.d/tailscale.repo -f