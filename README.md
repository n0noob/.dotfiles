# .dotfiles

## Prerequisites
Requires [gnu/stow](https://www.gnu.org/software/stow/)

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