#!/bin/bash

function get_volume {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk -F" " '{ print $2 }' | xargs
}

function is_mute {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -oE '[^ ]+$' | grep -q MUTED
}

function send_notification {
    volume=`get_volume`
    volume_int=`echo "scale=0; (($volume * 100)+0.5)/1" | bc`

    # echo $volume_int
    bar=$(seq -s '─' `echo "scale=0; $volume * 20" | bc` | sed 's/[0-9]//g')
    if is_mute; then
        dunstify "$volume_int%   ""$bar" -t 2000 -i "$HOME/.config/volume-notif/icons/mute-white.svg" -h string:x-dunst-stack-tag:volume-notify
    else
        if [[ $volume_int -eq 0 ]]; then
          dunstify "$volume_int%   ""$bar" -t 2000 -i "$HOME/.config/volume-notif/icons/mute-white.svg" -h string:x-dunst-stack-tag:volume-notify
        elif [[ $volume_int < 50 ]]; then
          dunstify "$volume_int%   ""$bar" -t 2000 -i "$HOME/.config/volume-notif/icons/min-white.svg" -h string:x-dunst-stack-tag:volume-notify
      else
          dunstify "$volume_int%   ""$bar" -t 2000 -i "$HOME/.config/volume-notif/icons/max-white.svg" -h string:x-dunst-stack-tag:volume-notify
        fi
    fi
}

function mute {
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle 
}

function increment {
    volume=`get_volume`
    next_vol=`echo "(($volume + 0.05)*100+0.5)/1" | bc`
    if [[ $next_vol -le 100 ]]; then
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
    fi
} 

function decrement {
   wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
}

case $1 in 
    "mute")
        mute
        send_notification
    ;;
    "increment")
        increment
        send_notification
    ;;
    "decrement")
        decrement
        send_notification
    ;;
esac


