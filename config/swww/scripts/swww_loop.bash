#!/bin/bash

# This script will sequentially go through the files of a directory, setting it
# up as the wallpaper at regular intervals

if [[ $# -lt 1 ]] || [[ ! -d $1   ]]; then
	echo "Usage:
	$0 <dir containing images>"
	exit 1
fi

# Edit below to control the images transition
export SWWW_TRANSITION_FPS=60
export SWWW_TRANSITION_STEP=2

# This controls (in seconds) when to switch to the next image
INTERVAL=300

INDEX=0
while true; do
          find "$1" -type f \
          	| while read -r img; do
          		echo "$((INDEX += 1)):$img"
          	done \
          	| sort -n | cut -d':' -f2- \
          	| while read -r img; do
          		echo "$img"
                        swww img "$img"
          		sleep $INTERVAL
          	done
done
