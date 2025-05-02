#!/bin/bash

thresholdRamPercent=80 # Should be an integer

while true ; do

    # Get used RAM % via free(1) .
    usedRamPercent=$(free | grep Mem | awk '{print $3/$2 * 100.0}' | sed 's/\..*$//g')

    # Get used RAM % via python's psutil.
    #usedRamPercent=$(python3 -c 'import psutil ; print(psutil.virtual_memory().percent)' | sed 's/\..*$//g')
    
    warningMessage="WARNING: RAM usage is $usedRamPercent (%) above $thresholdRamPercent percentage limit. Please free some RAM!"


    if [ $usedRamPercent -ge $thresholdRamPercent ] ; then
        # Send a notification
        notify-send -u critical -i dialog-warning "$warningMessage"
        # Speak it out.
        spd-say "$warningMessage"
        # Display the warning in a window.
        # Waits until "OK" is clicked / window closed.
        zenity --info --height=240 --width=480 --text "${warningMessage}\n\
        Press OK to continue monitoring. Close this dialog to quit monitoring." || exit 1
    fi

    # Refresh every 15 seconds
    sleep 15

done
