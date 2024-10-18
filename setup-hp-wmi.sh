#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"
sed -i 's/enabled=1/enabled=0/' /etc/yum.repos.d/*updates-*.repo
rpm-ostree install akmods
rpm-ostree install --idempotent /tmp/akmod-hp-wmi-0-0.10.x86_64.rpm  /tmp/hp-wmi-0-0.10.x86_64.rpm /tmp/kmod-hp-wmi-0-0.10.x86_64.rpm
sed -i 's/enabled=0/enabled=1/' /etc/yum.repos.d/*updates-*.repo