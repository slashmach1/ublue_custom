#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"
##setup repos
curl https://pkgs.tailscale.com/stable/fedora/tailscale.repo -o /etc/yum.repos.d/tailscale.repo
rpm-ostree install wireguard-tools tailscale distrobox openresolv iwd android-tools steam-devices /tmp/*.rpm
rm /etc/yum.repos.d/tailscale.repo -f