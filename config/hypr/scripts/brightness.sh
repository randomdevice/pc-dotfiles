#!/bin/bash

# Usage: ./brightness.sh up OR ./brightness.sh down

# Function to get the current brightness percentage
function get_brightness {
    # Returns just the number (e.g., 45)
    brightnessctl -m | awk -F, '{print substr($4, 1, length($4)-1)}'
}

function send_notification {
    brightness_int=$(get_brightness)

    # Calculate the bar length (20 steps total)
    # Using 1/5th of the percentage for a 20-character bar
    bar_size=$(( brightness_int / 5 ))
    bar=$(seq -s '─' $bar_size 2>/dev/null | sed 's/[0-9]//g')
 
    # Send notification using a brightness-specific stack tag
    # Icons are ignored as requested
    dunstify -h string:x-dunst-stack-tag:brightness-notify \
	     -i 'weather-clear' \
             -u low \
             -t 2000 \
             "    $brightness_int%    $bar"
}

case $1 in
    "increment")
        brightnessctl set +5%
        send_notification
    ;;
    "decrement")
        # Prevents going below 1% so the screen doesn't turn off
        current=$(get_brightness)
        if [ "$current" -gt 5 ]; then
            brightnessctl set 5%-
        else
            brightnessctl set 5%
        fi
        send_notification
    ;;
esac
