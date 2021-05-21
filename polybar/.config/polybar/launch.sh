#!/usr/bin/env sh

# Kill current running instances
killall -q polybar

# Wait until they're dead
while pgrep -x polybar >/dev/null; do sleep 1; done

# Launch bars
polybar -rq tray &
#polybar -rq spotify &
polybar -rq workspace &

