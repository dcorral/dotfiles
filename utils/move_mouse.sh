#!/bin/bash

get_mouse_position() {
    eval $(xdotool getmouselocation --shell)
    echo "$X $Y"
}

move_mouse() {
    local current_position=$(get_mouse_position)
    local x=$(echo $current_position | cut -d' ' -f1)
    local y=$(echo $current_position | cut -d' ' -f2)

    xdotool mousemove $x $((y - 1))
    xdotool mousemove $x $((y))

    notify-send "Mouse Moved" "Mouse moved to $x,$((y - 1)) and back to $x,$y"
}

while true; do
    move_mouse
    sleep 60
done
