# .dotfiles

## Prerequisites
Requires [gnu/stow](https://www.gnu.org/software/stow/) for dotfiles management.

Essentials:
```
# pacman -S paru stow 
```

In addition, following dependencies are required:

* BSPWM:

```
$ paru -S bspwm sxhkd rofi dunst feh polybar xidlehook thunar kitty polkit-gnome picom networkmanager neovim maim i3lock arandr xclip
```

* hyprland:

```
$ paru -S hyprland wofi waybar dunst wlogout polkit-gnome ttf-jetbrains-mono-nerd thunar kitty swww swaync swaylock-effects networkmanager neovim gamemode cliphist btop hyprshot
```

Some generic packages:
```
# pacman -S mpv yt-dlp refind nwg-look-bin meld git code gnome-screenshot
```

## Home location
dotfiles home location:
```
~/.dotfiles
```

## Steps for backing up dotfiles
Backup dotfiles like this:
```
cp -R ~/.config/waybar ~/.dotfiles/waybar/.config
```

Using gnu/stow link the dotfiles under `~/.dotfiles` like this:
```
stow --adopt waybar
```

Viola, waybar configuration files have been backed up. `~/.config/waybar` should contain only the symlinks to your git managed dot files.