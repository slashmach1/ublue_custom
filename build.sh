#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"


### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1
#flatpak changes
flatpak uninstall --all --delete-data --assumeyes  # prefered flathub remote
flatpak remote-modify --disable fedora
flatpak remote-delete --system flathub  # remove filtered flathub remote
flatpak remote-add --system --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-modify --enable flathub
flatpak install flathub \
    org.mozilla.firefox \
    org.freedesktop.Platform.ffmpeg-full  `# for firefox hardware decoding` \
    com.github.tchx84.Flatseal 
    
#overrides
rpm-ostree override remove firefox firefox-langpacks fedora-workstation-repositories

# this installs a package from fedora repos
rpm-ostree install distrobox

#config
echo "AutomaticUpdatePolicy=stage" | sudo tee --append /etc/rpm-ostreed.conf
