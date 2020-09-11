#!/bin/bash

if [ "$(playerctl --player=playerctld status)" = "Stopped" ]; then
    echo ""
elif [ "$(playerctl --player=playerctld status)" = "Paused"  ]; then
    playerctl  --player=playerctld metadata --format "Paused"
else
    playerctl --player=playerctld metadata --format "{{ title }} - {{ artist }}"
fi
