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
# paru -S zsh mpv exa refind nwg-look-bin meld git code hyprshot fd fzf
```
# Manual installations and configurations

* Install [oh-my-zsh](https://ohmyz.sh/)
* Change default shell to `zsh`:
```
chsh -s $(which zsh)
```
* Change default theme using `nwg-look` utility in hyprland

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
