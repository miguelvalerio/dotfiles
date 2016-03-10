#!/bin/bash

. $(dirname $0)/lemonbar_config

if [ $(pgrep -cx $(basename $0)) -gt 1 ] ; then
    printf "%s\n" "The status bar is already running." >&2
    exit 1
fi

trap 'trap - TERM; kill 0' INT TERM QUIT EXIT

volume() {
    while read -r subscribe; do
        case "${subscribe}" in
            *sink*)
                vol=$(amixer get Master | grep % | sed -n 1p | awk -F '[' '{print $2}' | awk -F ']' '{print $1}' | sed s/%//) 
                if [ "${vol}" -ge 50 ]; then
                    vol_icon=${VOL_UP_ICON}
                elif [ "${vol}" -gt 0 ]; then
                    vol_icon=${VOL_DOWN_ICON}
                else
                    vol_icon=${VOL_OFF_ICON}
                fi
                echo -e "VOL%{A4:amixer set Master 5\%+:}%{A5:amixer set Master 5\%-:}%{B${VOL_BG}}%{F${VOL_ICON_FG}} ${vol_icon} %{F${VOL_FG}}${vol}%{A}%{A} "
                ;;
        esac
    done < <(echo "sink" && pactl subscribe)
}

calendar() {
    while :; do
        cal=$(date +'%A, %d %B %Y')
        echo -e "DATE%{F${DATE_ICON_FG}}%{B${DATE_BG}} ${CALENDAR_ICON} %{F${DATE_FG}}${cal} "
        sleep $DATE_TIMER
    done
}

clock() {
    while :; do
        time="$(date +"%R")"
        echo -e "CLOCK%{F${TIME_ICON_FG}}%{B${TIME_BG}} ${TIME_ICON} %{F${TIME_FG}}${time} "
        sleep $CLOCK_TIMER
    done
}

song_cycle() {
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
            song="${contents:${count}:${SONG_MAX_LENGTH}}"
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
        echo -e "$song"
        sleep 0.25
    done
}

music() {
    while read -r dummy; do
        { 
            while IFS='' read -r song; do
                status=$(mpc | head -2 | tail -1 | awk '{print $1;}' | tr -d '[]')
                case $status in
                    "playing")
                        song="${PLAY_ICON} ${song}"
                        ;;
                    "paused")
                        song="${PAUSE_ICON} ${song}"
                        ;;
                    *)
                        song="RIP"
                        ;;
                esac
                time="[$(mpc | awk 'NR==2 {print $3}')]"
                echo -e "MUSIC%{A4:mpc next:}%{A5:mpc prev:}%{A:mpc toggle:}%{B${MUSIC_BG}}%{F${BAR_BG}}${SEP_R} %{F${MUSIC_FG}}%{B${MUSIC_BG}}${song} $time %{F${BAR_BG}}%{B${MUSIC_BG}}${SEP_L}%{A}%{A}%{A}"
            done
        } < <(song_cycle)
    done < <(echo "dummy" && mpc idleloop)
}

workspaces() {
    while read -r ws ; do
        wsp=
        set -- ${ws}
        while [ $# -gt 0 ]; do
            IFS=, read -ra workspace <<< "$1"
            IFS=- read -ra ws_name <<< "${workspace[0]}"
            if [ "${workspace[1]}" = true ]; then
                this_ws="%{B${FOC_BG}}%{F${FOC_FG}}  ${ws_name[1]}  "
                [ "$UNDERLINE_MODE" = true ] && this_ws="%{+uU${UNDERLINE}}${this_ws}%{-u}"
                wsp="${wsp}${this_ws}"
            else
                this_ws="%{B${ACT_BG}}%{F${ACT_FG}}  ${ws_name[1]}  "
                this_ws="%{A1:i3-msg workspace ${workspace[0]}:}${this_ws}%{A}"
                wsp="${wsp}${this_ws}"
            fi
            shift
        done
        echo "WS${wsp}"
        #process substitution
    done < <(echo $(python2.7 $(dirname $0)/ipc.py -t get_workspaces | sed "s/u'/'/g" | sed -u -e "s/'/\"/g" -e "s/False/false/g" -e "s/True/true/g" | jq --unbuffered -r 'def s(s): s | tostring; map(.name + "," + s(.focused) + " ") | reduce .[] as $item (""; . + $item)') && python $(dirname $0)/ipc.py -t subscribe workspace | sed -u -e "s/'/\"/g" -e "s/False/false/g" -e "s/True/true/g" | jq --unbuffered -r 'def s(s): s | tostring; map(.name + "," + s(.focused) + " ") | reduce .[] as $item (""; . + $item)')
}

{
    >(calendar) >(volume) >(clock) >(music) >(workspaces) | while IFS= read -r line; do
    case "$line" in
        WS*)
            lemon_ws=${line#??}
            ;;
        DATE*)
            lemon_date=${line#????}
            ;;
        MUSIC*)
            lemon_music=${line#?????}
            ;;
        VOL*)
            lemon_vol=${line#???}
            ;;
        DATE*)
            lemon_date=${line#????}
            ;;
        CLOCK*)
            lemon_clock=${line#?????}
            ;;
    esac
    bar="%{B${BAR_BG}}%{l}${lemon_ws}%{B$BAR_BG}%{F$BAR_FG}%{c}$lemon_music%{r}${lemon_vol}${lemon_clock}${lemon_date}%{B${BAR_BG}}"
    echo "${bar}"
done
} | lemonbar -g x${BAR_HEIGHT} -f "${FONT1}" -f "${FONT2}" -u 2 -o "${FONT1_OFFSET}" -o "${FONT2_OFFSET}" -a 100 | sh
