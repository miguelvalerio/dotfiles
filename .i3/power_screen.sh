#!/bin/bash

option=$(echo "poweroff;lock;restart" | rofi -sep ";" -dmenu -p "power:" -padding 20 -bw 5 -width 20)
case "$option" in
    "poweroff")
        poweroff
        ;;
    "lock")
        ./$(dirname $0)/lock.sh
        ;;
    "reboot")
        reboot
        ;;
esac
