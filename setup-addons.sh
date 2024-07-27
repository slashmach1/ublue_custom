#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"
##setup repos
curl https://pkgs.tailscale.com/stable/fedora/tailscale.repo -o /etc/yum.repos.d/tailscale.repo
wget https://copr.fedorainfracloud.org/coprs/kylegospo/system76-scheduler/repo/fedora-$(rpm -E %fedora)/kylegospo-system76-scheduler-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_kylegospo-system76-scheduler.repo
rpm-ostree install system76-scheduler tailscale ptyxis
#rpm-ostree install --idempotent /tmp/*xpadneo*.rpm
rm /etc/yum.repos.d/tailscale.repo -f
rm /etc/yum.repos.d/_copr_kylegospo-system76-scheduler.repo -f
systemctl enable --now com.system76.Scheduler.service