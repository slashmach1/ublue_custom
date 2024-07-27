#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"
rpm-ostree install --idempotent /tmp/akmod-hp-wmi-0-0.10.x86_64.rpm  /tmp/hp-wmi-0-0.10.x86_64.rpm /tmp/kmod-hp-wmi-0-0.10.x86_64.rpm
