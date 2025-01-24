#!/bin/sh

# Get the current volume percentage of the default sink (output device)
volume=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | tr -d '%')

# Get mute status (0 = unmuted, 1 = muted)
mute=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')

# If muted, use the Font Awesome volume-muted icon
if [ "$mute" == "yes" ]; then
    echo " Muted"   # Muted volume icon
else
    echo " $volume%"  # Regular volume icon
fi
