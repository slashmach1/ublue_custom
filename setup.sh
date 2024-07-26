#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"
## file and service changes
cp -r /tmp/NetworkManager/. /usr/lib/NetworkManager/
cp -r /tmp/modprobe.d/. /usr/lib/modprobe.d/
cp -r /tmp/lib/sysctl.d/. /usr/lib/sysctl.d/
cp -r /tmp/lib/systemd/. /usr/lib/systemd/
cp /tmp/rpm-ostreed.conf /etc/rpm-ostreed.conf
chmod go-w /usr/lib/systemd/system/*.*
systemctl enable dconf-update.service
systemctl enable flatpak-add-flathub-repo.service
systemctl enable flatpak-replace-fedora-apps.service
systemctl enable flatpak-cleanup.timer
systemctl enable rpm-ostreed-automatic.timer
systemctl disable wpa_supplicant.service

##setup repos
curl https://pkgs.tailscale.com/stable/fedora/tailscale.repo -o /etc/yum.repos.d/tailscale.repo
#cat << EOF > /etc/yum.repos.d/google-chrome.repo
#[google-chrome]
#name=google-chrome
#baseurl=https://dl.google.com/linux/chrome/rpm/stable/x86_64
#enabled=1
#gpgcheck=1
#repo_gpgcheck=1
#gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-google
#EOF
#curl --retry 3 --retry-delay 2 --retry-all-errors -sL \
#  -o /etc/pki/rpm-gpg/RPM-GPG-KEY-google \
#  https://dl.google.com/linux/linux_signing_key.pub
#rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-google
wget https://copr.fedorainfracloud.org/coprs/kylegospo/system76-scheduler/repo/fedora-$(rpm -E %fedora)/kylegospo-system76-scheduler-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_kylegospo-system76-scheduler.repo
## package installs
#rpm-ostree install distrobox system76-scheduler google-chrome-stable ffmpeg gstreamer1-plugin-libav gstreamer1-plugins-bad-free-extras gstreamer1-plugins-bad-freeworld gstreamer1-plugins-ugly gstreamer1-vaapi libva-nvidia-driver intel-media-driver libva-intel-driver openresolv iwd android-tools ptyxis tailscale wireguard-tools
rpm-ostree install distrobox system76-scheduler openresolv iwd android-tools tailscale wireguard-tools steam-devices
## akmods installs
rpm-ostree install --idempotent /tmp/*xpadneo*.rpm #/tmp/hp-wmi-0-0.10.x86_64.rpm /tmp/akmod-hp-wmi-0-0.10.x86_64.rpm 
## overrides
rpm-ostree override remove fedora-workstation-repositories firefox firefox-langpacks toolbox
## cleanup
rm /etc/yum.repos.d/tailscale.repo -f
#rm /etc/yum.repos.d/google-chrome.repo -f
rm /etc/yum.repos.d/_copr_kylegospo-system76-scheduler.repo -f

## enable system76 scheduler
systemctl enable --now com.system76.Scheduler.service

##chrome post setup
#mv /var/opt/google /usr/lib/google # move this over here
#####
# Register path symlink
# We do this via tmpfiles.d so that it is created by the live system.
#cat >/usr/lib/tmpfiles.d/google.conf <<EOF
#L  /opt/google  -  -  -  -  /usr/lib/google
#EOF