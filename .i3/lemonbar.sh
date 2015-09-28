#!/bin/bash

. $(dirname $0)/lemonbar_config

PANEL_FIFO="/tmp/i3_lemonbar_${USER}"

if [ $(pgrep -cx $(basename $0)) -gt 1 ] ; then
    printf "%s\n" "The status bar is already running." >&2
    exit 1
fi

trap 'trap - TERM; kill 0' INT TERM QUIT EXIT

[ -e "${PANEL_FIFO}" ] && rm "${PANEL_FIFO}"
mkfifo "${PANEL_FIFO}"

$(dirname $0)/i3_workspaces.py > "${PANEL_FIFO}" &

while :; do
    echo "VOL$(amixer get Master | awk -F"[]%[]" '/%/ { sum += $2; n++ } END { if (n > 0) print sum/n;}')"
    sleep 1
done > $PANEL_FIFO &

while :; do
    echo "DATE$(date +"%A, %d %B %Y")"
    echo "TIME$(date +"%R")"
    sleep 5
done > $PANEL_FIFO &

while :; do
    contents=$(mpc current --format "%artist% - %title%")
    if [ "$prev_contents" != "$contents" ]; then
        prev_contents=${contents}
        count=0
        increment=1
        timer=0
        stop=1
    fi
    if [ ${#contents} -gt ${SONG_MAX_LENGTH} ]; then
        end=$((count+SONG_MAX_LENGTH))
        song=${contents:${count}:${SONG_MAX_LENGTH}}
        if [ ${stop} -eq 0 ]; then
            timer=$((timer+1))
            if [ ${timer} -eq 5 ]; then
                stop=1
                timer=0
                count=$((count+increment))
            fi
        else
            if [ ${end} -eq ${#contents} ]; then
                stop=0
                increment=-1
            elif [ ${count} -eq 0 ]; then
                stop=0
                increment=1
            fi
            [ "${stop}" -eq 1 ] && count=$((count+increment))
        fi
    else
        song=${contents}
    fi
    echo "MUS$(mpc | awk 'NR==2 {print $1}')${song} [$(mpc | awk 'NR==2 {print $3}')]"
    sleep 0.25
done > $PANEL_FIFO &

while :; do
    echo "SSID$(iw dev ${DEVICE} link | grep SSID | awk '{print $2}')"
    sleep 5
done > $PANEL_FIFO &

cat "${PANEL_FIFO}" | $(dirname $0)/lemonbar_parser.sh | lemonbar -g ${BAR_LENGTH}x${BAR_HEIGHT}+${H_GAP}+${V_GAP} -d -f "${FONT1}" -f "${FONT2}" | sh

