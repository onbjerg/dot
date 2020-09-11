#!/usr/bin/env sh

# Kill current running instances
killall -q polybar

# Wait until they're dead
while pgrep -x polybar >/dev/null; do sleep 1; done

# Launch polybar
MONITOR=DP-0 polybar primary &
MONITOR=DP-2 polybar secondary &
