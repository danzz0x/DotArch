#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

polybar left &
polybar center &
polybar right &
polybar power &
# Launch bar
echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
#polybar bar1 2>&1 | tee -a /tmp/polybar1.log & disown

echo "Bars launched..."
