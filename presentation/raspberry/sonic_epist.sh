#!/bin/bash

# the institute of sonic epistemologies
# zeller/rumori 2016-04

SCENE=$1
if [ -z $SCENE ]; then SCENE="A"; fi

TRACK="/home/pi/sonic_epist/snd/Sonic Epist - Scene $SCENE.flac"
DEVICE="hw=1"
GPIO_HEAD=15	# headphone trigger
KILLTIMER=30    # timeout for stop playing after hangup, 1/10 s
GPIO_POWEROFF=3     # shutdown trigger
POWEROFFTIMER=50    # timeout for shutdown, 1/10 s

# acquire gpio system interface
if [ ! -e /sys/class/gpio/gpio${GPIO_HEAD} ]; then
    sudo echo "$GPIO_HEAD" > /sys/class/gpio/export
    sleep 0.2 # apparently race condition otherwise
    echo "1" > /sys/class/gpio/gpio${GPIO_HEAD}/active_low;
fi
if [ ! -e /sys/class/gpio/gpio${GPIO_POWEROFF} ]; then
    sudo echo "$GPIO_POWEROFF" > /sys/class/gpio/export
    sleep 0.2 # apparently race condition otherwise
    echo "1" > /sys/class/gpio/gpio${GPIO_POWEROFF}/active_low;
fi

PLAYING=0
KILLT=$KILLTIMER
POWEROFFT=$POWEROFFTIMER

while [ 1 ]; do

    # poweroff by gpio detection
    POWEROFF=`cat /sys/class/gpio/gpio${GPIO_POWEROFF}/value`

    if [ $POWEROFF -gt 0 ]; then
	POWEROFFT=$((POWEROFFT-1))
	if [ $POWEROFFT -le 0 ]; then
	    sudo poweroff;
	fi;
    else
	POWEROFFT=$POWEROFFTIMER;
    fi	   

    # playback ctrl via gpio
    HEAD=`cat /sys/class/gpio/gpio${GPIO_HEAD}/value`

    if [ $HEAD -gt 0 ]; then
        if [ $PLAYING -gt 0 ]; then
            KILLT=$KILLTIMER;
        else
            # start playing
            PLAYING=1
            KILLT=$KILLTIMER;
	    mplayer --really-quiet --ao=alsa:device=$DEVICE "$TRACK" &
	    PLAYER_PID=$!
        fi;
    else
        if [ $PLAYING -gt 0 ]; then
	    KILLT=$((KILLT-1))
	    if [ $KILLT -le 0 ]; then
		kill $PLAYER_PID
		PLAYING=0;
            fi;
        fi;
    fi
   sleep 0.1; # 1/10s timing granularity
done

# EOF
