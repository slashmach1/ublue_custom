#!/bin/bash

set -ouex pipefail

## flatpak setup
flatpak remote-add --if-not-exists --system flathub https://flathub.org/repo/flathub.flatpakrepo