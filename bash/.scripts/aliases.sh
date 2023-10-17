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
alias paru='paru --removemake'
