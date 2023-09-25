#!/usr/bin/env bash

declare -r BAR_NAME=one
declare -r LOG=/tmp/polybar-${BAR_NAME}.log

# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use
# polybar-msg cmd quit

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

# xrandr was still detecting disconnected monitors
# xrandr --auto

rm -f $LOG

for monitor in $(polybar --list-monitors | cut -d":" -f1); do
#for monitor in $(xrandr --listactivemonitors | grep -v 'Monitors' | cut -d " " -f6); do
    echo "Starting $BAR_NAME bar on monitor $monitor" 2>&1 | tee -a $LOG
    MONITOR=$monitor polybar --reload $BAR_NAME 2>&1 | tee -a $LOG & disown
done

echo "Bars launched..."
