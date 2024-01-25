#!/bin/bash

# Check if the script is being run as root, if not, exit with a message
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Define the configuration file path
conf_file="/etc/modprobe.d/scarlett.conf"

# Write the configuration for snd-usb-audio to the conf_file
echo "Creating $conf_file with the appropriate configuration..."
echo "options snd_usb_audio vid=0x1235 pid=0x8211 device_setup=1" > "$conf_file"

# Inform the user to reload the snd-usb-audio module
echo "Reloading snd-usb-audio module..."
modprobe -r snd_usb_audio
modprobe snd_usb_audio

# Check if the Focusrite Scarlett Gen 2/3 Mixer Driver is present
echo "Checking for Focusrite Scarlett Gen 2/3 Mixer Driver..."
dmesg | grep Scarlett

# Inform the user that they may need to reboot
echo "If the Focusrite Scarlett Gen 2/3 Mixer Driver is not listed above,"
echo "you may need to reboot your system for the changes to take effect."

# End of the script

