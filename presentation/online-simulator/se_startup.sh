#!/bin/bash

# startup sonic epistemologies

# no screensaver
xset s off -dpms

# adjust volume
amixer set Headphone 18

# start browser fullscreen
cd /home/pi/se && chromium-browser --start-fullscreen --kiosk sonic_epistemologies.html
