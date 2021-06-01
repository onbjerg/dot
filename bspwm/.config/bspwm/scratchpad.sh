#!/bin/bash

help() {
  echo "Usage: $(basename $0) <command>"
  echo "Commands:"
  echo "    hide    Sends the current focused node to the scratchpad"
  echo "    show    Pulls a node from the scratchpad"
}

hide() {
  bspc node --flag hidden
}

show() {
  hidden_window_ids=($(bspc query -N -n .hidden.window))
  selected_id=""
  if [ "${#hidden_window_ids[@]}" -gt "1" ]; then
    opts="$(xtitle "${hidden_window_ids[@]}")"

    selected_id="$(<<< "$opts" rofi -dmenu -i -format i -markup-rows -no-show-icons)"
  else
    selected_id="0"
  fi
  if [ -n "${selected_id}" ]; then
    bspc node "${hidden_window_ids[${selected_id}]}" -g hidden=off --to-monitor focused --focus
  fi
}

case $1 in
  "" | "-h" | "--help")
    help
    ;;
  "hide")
    shift
    hide
    ;;
  "show")
    shift
    show
    ;;
esac
