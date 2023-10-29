#alias ls='ls --color=auto'
alias ls="exa --color=always --group-directories-first"
#alias ll='ls -lv --ignore=..'   # show long listing of all except ".."
alias ll="exa -l --color=always --group-directories-first"
alias vim='nvim'

alias mpvs='mpv --no-audio'
alias mpvsfs='mpv --no-audio --fullscreen'


# pacman and AUR helper
alias pac-list-installed='pacman -Qqe'
alias pac-list-unused='pacman -Qdtq'
alias pac-info='pacman -Qi'
alias pac-search-installed='pacman -Qs'


# find random files in current directory
get_random_file() {
    # set -v -x -e
    dir=$1

    # if variable dir is set but does not point to a valid directory
    if [[ "$dir" ]]; then
        if [[ ! -d "$dir" ]]; then 
            echo "Passed directory path does not exist"
            return 1
        else
            dir="$(pwd -P)/$dir"
        fi 
    else 
        # if dir was not passed, set dir to current directory
        dir="$(pwd -P)"
    fi

    find "$dir" -type f | shuf -n 1
    # set +v +x +e
}


# dotfiles backup
backup_package() {
    package=$1

    # Show warning if package already exists
    if [[ -e ~/.dotfiles/$package ]]; then 
        echo "${package} already backed up."
        read -p "Press any key to start overwriting the backup"
    fi

    if [[ -d ~/.config/$package ]]; then
        echo "$package is a directory"
        if [[ ! -e ~/.dotfiles/$package ]]; then 
            mkdir -p ~/.dotfiles/$package/.config/$package
        fi
    elif [[ -f ~/.config/$package ]]; then
        echo "$package is a file"
    else
        echo "$package is not valid"
        return 1
    fi

    echo "Backing up $package from .config"
    
    cp -Rf ~/.config/$package ~/.dotfiles/$package/.config/
    ( cd ~/.dotfiles && stow --adopt $package )
}
