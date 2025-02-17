#!/bin/bash

current_sink=$(pactl get-default-sink)
display_name=''

# Use exact sink names from `pactl list sinks`
if [[ "$current_sink" == *"alsa_output.pci-0000_01_00.1.hdmi-stereo"* ]]; then
    pactl set-default-sink "alsa_output.usb-Focusrite_Scarlett_Solo_USB_Y7RPXM11275CD2-00.HiFi__Line1__sink"
else
    pactl set-default-sink "alsa_output.pci-0000_01_00.1.hdmi-stereo"
fi

# Optional: Send notification
notify-send "Audio Output" "Switched to: $(pactl get-default-sink | awk -F'.' '{print $NF}')"
