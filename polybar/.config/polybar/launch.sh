#!/usr/bin/env sh

# Kill current running instances
killall -q polybar

# Wait until they're dead
while pgrep -x polybar >/dev/null; do sleep 1; done

# Launch bars
MONITOR=DP-2 polybar -rq tray &
MONITOR=DP-2 polybar -rq workspace &
MONITOR=DP-0 polybar -rq workspace &

# Launch Spotify bar and supporting script
MONITOR=DP-2 polybar -rq spotify &
ln -sf /tmp/polybar_mqueue.$! /tmp/ipc-spotify-bar
$HOME/.config/polybar/spotify_toggle_bar.sh &
