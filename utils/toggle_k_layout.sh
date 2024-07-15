#!/bin/bash

current_layout=$(setxkbmap -query | grep layout | awk '{print $2}')

if [ "$current_layout" = "us" ]; then
    setxkbmap es
    notify-send -i 'a' -t 3000 "Layout" "🇪🇸"
    echo "🇪🇸" >/home/dcorral/keyboard_layout
    killall -USR1 i3status
else
    setxkbmap us
    notify-send -i 'a' -t 3000 "Layout" "🇬🇧"
    echo "🇬🇧" >/home/dcorral/keyboard_layout
    killall -USR1 i3status
fi
