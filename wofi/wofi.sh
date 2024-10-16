#!/usr/bin/env bash
CONFIG="$HOME/.config/wofi/config/config"
STYLE="$HOME/.config/wofi/src/mocha/style.css"

if [[ ! $(pidof wofi) ]]; then
    wofi --conf "${CONFIG}" --style "${STYLE}" --show drun
else
    pkill wofi
fi