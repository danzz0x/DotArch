#!/bin/bash
xrandr --output HDMI1 --right-of eDP1 --auto
pactl set-default-sink $(pactl list sinks short | grep HDMI | awk '{print $1}')
