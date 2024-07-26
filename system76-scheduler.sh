#!/bin/bash
wget https://copr.fedorainfracloud.org/coprs/kylegospo/system76-scheduler/repo/fedora-$(rpm -E %fedora)/kylegospo-system76-scheduler-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_kylegospo-system76-scheduler.repo
rpm-ostree install system76-scheduler
systemctl enable --now com.system76.Scheduler.service
rm /etc/yum.repos.d/_copr_kylegospo-system76-scheduler.repo