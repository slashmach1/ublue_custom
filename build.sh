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
    com.github.tchx84.Flatseal \
    com.bitwarden.desktop \
    com.github.qarmin.czkawka 
    
#overrides
rpm-ostree override remove firefox firefox-langpacks fedora-workstation-repositories
rpm-ostree override remove mesa-va-drivers \
    --install intel-media-driver

mkdir -p /etc/rpm-ostree/origin.d

tee /etc/rpm-ostree/origin.d/intel-media-driver.yaml <<EOF
packages:
  - intel-media-driver
override-remove:
  - mesa-va-drivers
EOF

rpm-ostree ex rebuild

# this installs a package from fedora repos
rpm-ostree install distrobox
rpm-ostree install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

#kargs
rpm-ostree kargs --append=i915.enable_guc=2

#config
echo "AutomaticUpdatePolicy=stage" | sudo tee --append /etc/rpm-ostreed.conf
