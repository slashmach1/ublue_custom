#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"


### Install packages
rpm-ostree override remove \
    firefox \
    firefox-langpacks \
    fedora-workstation-repositories
rpm-ostree install distrobox 
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
rpm-ostree install google-chrome-stable_current_x86_64.rpm
rm google-chrome-stable_current_x86_64.rpm -f
echo "AutomaticUpdatePolicy=stage" | sudo tee --append /etc/rpm-ostreed.conf
