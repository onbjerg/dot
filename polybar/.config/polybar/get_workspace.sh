#!/bin/bash

if [[ $# = 0 ]]; then
  echo No monitor selected.
  exit 1
fi

bspc query -D -d ${1}:focused --names
bspc subscribe desktop_focus | while read -a msg ; do
  monitor_id=${msg[1]}
  desktop_id=${msg[2]}

  monitor_name=$(bspc query -M -m $monitor_id --names)

  if [ "$monitor_name" = "$1" ]; then
    bspc query -D -d $desktop_id --names
  fi
done
