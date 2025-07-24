#!/bin/bash

brillo=$(brightnessctl | grep -oP '\(\K[0-9]+(?=%\))')

#mostrar el brllo
echo "$brillo%"
