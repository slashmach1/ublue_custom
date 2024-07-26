# Setup flathub remote, remove fedora remote if present
setup-flatpak:
  flatpak remote-add --if-not-exists --system flathub https://flathub.org/repo/flathub.flatpakrepo
  flatpak uninstall --system --noninteractive `flatpak list --all --columns origin,application|grep ^fedora|awk '{print $2}'|xargs`
  flatpak remote-delete --system fedora --force
  flatpak install --noninteractive --system flathub \\
    app/org.kde.kcalc/x86_64/stable \\
    app/org.kde.gwenview/x86_64/stable \\
    app/org.kde.kontact/x86_64/stable \\
    app/org.kde.okular/x86_64/stable \\
    app/org.kde.kweather/x86_64/stable \\
    app/org.kde.kclock/x86_64/stable \\
    app/org.kde.haruna/x86_64/stable \\
    app/org.kde.filelight/x86_64/stable \\
    app/com.github.tchx84.Flatseal/x86_64/stable \\
    app/io.github.dvlv.boxbuddyrs/x86_64/stable \\
    app/it.mijorus.gearlever/x86_64/stable \\
    com.google.Chrome
  flatpak override --system --filesystem=~/.local/share/applications --filesystem=~/.local/share/icons com.google.Chrome