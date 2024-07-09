#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"


### Install packages
flatpak uninstall --all --delete-data --assumeyes \
&& flatpak remote-modify --disable fedora \
&& flatpak remote-delete --system flathub  \
&& flatpak remote-add --system --if-not-exists \
&& flatpak remote-modify --enable flathub \
&& flatpak install flathub \
    org.mozilla.firefox \
    org.freedesktop.Platform.ffmpeg-full \
    com.github.tchx84.Flatseal 
rpm-ostree override remove \
    firefox \
    firefox-langpacks \
    fedora-workstation-repositories
rpm-ostree install distrobox 
echo "AutomaticUpdatePolicy=stage" | sudo tee --append /etc/rpm-ostreed.conf
