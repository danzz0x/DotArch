#!/bin/bash

# Obtener el volumen y estado
volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2*100}')
muted=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -o '\[MUTED\]')

# Definir los iconos
if [ -n "$muted" ]; then
  icon="󰖁" # Icono de mute
  echo "$icon Mute"
elif [ "$volume" -eq 0 ]; then
  icon="󰕿" # Icono de volumen en 0%
  echo "$icon $volume%"
elif [ "$volume" -le 30 ]; then
  icon="󰖀" # Icono de volumen bajo
  echo "$icon $volume%"
else
  icon="󰕾" # Icono de volumen alto
  echo "$icon $volume%"
fi
