#!/bin/bash

set -ouex pipefail

## flatpak setup
flatpak remote-add --if-not-exists --system flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install --noninteractive --system flathub \
    app/org.fedoraproject.MediaWriter/x86_64/stable \
    app/org.kde.kcalc/x86_64/stable \
    app/org.kde.gwenview/x86_64/stable \
    app/org.kde.kontact/x86_64/stable \
    app/org.kde.okular/x86_64/stable \
    app/org.kde.kweather/x86_64/stable \
    app/org.kde.kclock/x86_64/stable \
    app/org.kde.haruna/x86_64/stable \
    app/org.kde.filelight/x86_64/stable \
    app/com.github.tchx84.Flatseal/x86_64/stable \
    app/io.github.dvlv.boxbuddyrs/x86_64/stable \
    app/io.github.flattool.Warehouse/x86_64/stable \
    app/org.fedoraproject.MediaWriter/x86_64/stable \
    app/io.missioncenter.MissionCenter/x86_64/stable \
    app/it.mijorus.gearlever/x86_64/stable \
    net.cozic.joplin_desktop \
    com.bitwarden.desktop \
    com.plexamp.Plexamp \
    org.signal.Signal \
    org.kde.kdenlive \
    org.kde.krita \
    com.discordapp.Discord