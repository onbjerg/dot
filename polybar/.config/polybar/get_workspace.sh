#!/bin/bash

# TODO: Limit to a specific monitor
bspc query -D -d focused --names
bspc subscribe desktop_focus | while read -a msg ; do
  monitor_id=${msg[1]}
  desktop_id=${msg[2]}
  
  monitor_name=$(bspc query -M -m $monitor_id --names)
  bspc query -D -d $desktop_id --names
done
