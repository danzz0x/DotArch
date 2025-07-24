#!/bin/bash

app_class=$(xprop -id "$(xdotool getwindowfocus)" WM_CLASS | awk -F\" '{print $4}')

case "$app_class" in
zen) echo "%{F#FF8C00}󰖟 %{F-}" ;;          # Cyan
discord) echo "%{F#7289da} %{F-}" ;;      # Azul Discord
obsidian) echo "%{F#a020f0}󰌔 %{F-}" ;;     # Morado
Code) echo "%{F#f1c40f} %{F-}" ;;         # Amarillo
Alacritty) echo "%{F#2ecc71}%{F-}" ;;     # Verde
*) echo "%{F#7289da}󰣇 $app_class %{F-}" ;; # Rojo para otros
esac

#
#para saber el nombre de la ventana activa
#xprop WM_CLASS
