#!/bin/bash

if [ "$(playerctl --player=spotify status)" = "Paused"  ]; then
    playerctl  --player=spotify metadata --format "Paused"
else
    playerctl --player=spotify metadata --format "{{ title }} - {{ artist }}"
fi
