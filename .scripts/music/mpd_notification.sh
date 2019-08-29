#!/bin/sh

while :; do
    [ -e /tmp/cover ] && break
    sleep 1
done

while :; do
    curr_song=$(mpc current)
    curr_album=$(mpc current --format "%album%")
    if [ "${prev_song}" != "${curr_song}" ]; then
        prev_song="${curr_song}"
        if [ "${prev_album}" != "${curr_album}" ]; then
            prev_album="${curr_album}"
            while [ "${prev_symlink}" == "$(realpath /tmp/cover)" ]; do
                :
            done
            prev_symlink=$(realpath /tmp/cover)
            convert /tmp/cover -thumbnail 70x70^ -gravity center -extent 70x70 /tmp/thumbnail.png
        fi
        $(dirname $0)/notify-send.sh --replace=100 "$(mpc current --format "\n%title%")" "$(mpc current --format "\n%artist%\n%album%")\n" -i /tmp/thumbnail.png
    fi
    mpc idle
    [ ! "$?" -eq 0 ] && sleep 0.5
done
