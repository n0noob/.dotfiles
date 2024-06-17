#!/usr/bin/env bash

LAYOUT="$HOME/.config/wlogout/layout"
STYLE="$HOME/.config/wlogout/style.css"

if [[ ! `pidof wlogout` ]]; then
    wlogout --layout ${LAYOUT} --css ${STYLE} \
        --buttons-per-row 2 \
        --column-spacing 70 \
        --row-spacing 70 \
        --margin-top 220 \
        --margin-bottom 220 \
        --margin-left 380 \
        --margin-right 380
else
    pkill wlogout
fi
