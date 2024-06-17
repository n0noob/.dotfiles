sudo sed -i -e 's/Exec=Hyprland/Exec=env WLR_NO_HARDWARE_CURSORS=1 Hyprland/g' /usr/share/wayland-sessions/hyprland.desktop
