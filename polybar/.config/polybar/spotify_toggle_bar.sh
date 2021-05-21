#!/bin/bash

echo "cmd:hide" >/tmp/ipc-spotify-bar
playerctl --player=spotify status --format "{{ lc(status) }}" --follow | while read -a status ; do
  if [ "$status" = "stopped" ] || [ "$status" = "" ]; then
    echo "cmd:hide" >/tmp/ipc-spotify-bar
  else
    echo "cmd:show" >/tmp/ipc-spotify-bar
  fi
done
