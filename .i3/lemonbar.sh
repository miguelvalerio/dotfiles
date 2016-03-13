#!/bin/bash

. $(dirname $0)/lemonbar_config

if [ $(pgrep -cx $(basename $0)) -gt 1 ] ; then
    printf "%s\n" "The status bar is already running." >&2
    exit 1
fi

trap 'trap - TERM; kill 0' INT TERM QUIT EXIT

prompt_segment() {
    if [[ "$1" == "LEFT" ]]; then
        sep="${SEP_L}"
        sep_l="${SEP_L_L}"
    else
        sep="${SEP_R}"
        sep_l="${SEP_R_L}"
    fi
    if [[ "$POWERLINE_MODE" = true ]]; then
        sep="%{T3}"${sep}"%{T-}"
        sep_l="%{T3}"${sep_l}"%{T-}"
    fi
    if [[ $2 != 'NONE' && $2 != $3 ]]; then
        [[ "$1" == "RIGHT" ]] && echo -e "%{B$3}%{F$2}${sep}%{F$4}%{B$3}" || echo -e "%{B$2}%{F$3}${sep}%{F$4}%{B$3}"
    elif [[ $2 != 'NONE' && $2 == $3 ]]; then
        echo -e "%{B$3}%{F$4}${sep_l}"
    else
        echo -e "%{B$3}%{F$4}"
    fi
}

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
                echo -e "VOL$(prompt_segment "LEFT" ${BAR_BG} ${VOL_BG} ${VOL_FG}) %{A4:amixer set Master 5%+:}%{A5:amixer set Master 5%-:}${vol_icon} ${vol}%{A}%{A} "
                ;;
        esac
    done < <(echo "sink" && pactl subscribe)
}

calendar() {
    while :; do
        cal=$(date +'%a, %d %b %Y')
        echo -e "DATE$(prompt_segment "LEFT" ${TIME_BG} ${DATE_BG} ${DATE_FG}) ${CALENDAR_ICON} ${cal} "
        sleep $DATE_TIMER
    done
}

clock() {
    while :; do
        time="$(date +"%H:%M")"
        echo -e "CLOCK$(prompt_segment "LEFT" ${VOL_BG} ${TIME_BG} ${TIME_FG}) ${TIME_ICON} ${time} "
        sleep $CLOCK_TIMER
    done
}

song_cycle() {
    while :; do
        contents="$(mpc current --format "%artist% - %title%")"
        if [ "$prev_contents" != "$contents" ]; then
            prev_contents="${contents}"
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
            song="${contents}"
        fi
        echo -e "$song"
        sleep 0.25
    done
}

music() {
    while read -r dummy; do
        { 
            while IFS= read -r song; do
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
                echo -e "MUSIC$(prompt_segment "RIGHT" ${BAR_BG} ${MUSIC_BG} ${MUSIC_FG}) %{A4:mpc next:}%{A5:mpc prev:}%{A1:mpc toggle:}${song} ${time}%{A}%{A}%{A} $(prompt_segment "LEFT" ${MUSIC_BG} ${BAR_BG} ${BAR_FG})"
            done
        } < <(song_cycle)
    done < <(echo "dummy" && mpc idleloop)
}

power_menu() {
    while :; do
        echo -e "POWER$(prompt_segment "LEFT" ${DATE_BG} ${POWER_BG} ${POWER_FG}) %{A1:$(dirname $0)/power_screen.sh:}${POWER_ICON}%{A} "
        sleep 30
    done
}

workspaces() {
    [[ "$POWERLINE_MODE" = false ]] && ws_space="  " || ws_space=" "
    while read -r ws ; do
        prev_ws_bg=${BAR_BG}
        wsp=
        set -- ${ws}
        while [ $# -gt 0 ]; do
            IFS=, read -ra workspace <<< "$1"
            IFS=- read -ra ws_name <<< "${workspace[0]}"
            [[ "$wsp" == "" ]] && space="" || space=" "
            if [ "${workspace[1]}" = true ]; then
                this_ws="${space}$(prompt_segment "RIGHT" ${prev_ws_bg} ${FOC_BG} ${FOC_FG})%{A1:i3-msg workspace back_and_forth:}  ${ws_name[1]}${ws_space}%{A}"
                [ "$UNDERLINE_MODE" = true ] && this_ws="%{+uU${UNDERLINE}}${this_ws}%{-u}"
                wsp="${wsp}${this_ws}"
                prev_ws_bg=${FOC_BG}
            else
                this_ws="${space}$(prompt_segment "RIGHT" ${prev_ws_bg} ${ACT_BG} ${ACT_FG})%{A1:i3-msg workspace ${workspace[0]}:}  ${ws_name[1]}${ws_space}%{A}"
                wsp="${wsp}${this_ws}"
                prev_ws_bg=${ACT_BG}
            fi
            shift
        done
        wsp="${wsp} $(prompt_segment "RIGHT" ${prev_ws_bg} ${BAR_BG} ${BAR_FG})"
        echo "WS${wsp}"
        #process substitution
    done < <(echo $(python2.7 $(dirname $0)/ipc.py -t get_workspaces | sed "s/u'/'/g" | sed -u -e "s/'/\"/g" -e "s/False/false/g" -e "s/True/true/g" | jq --unbuffered -r 'def s(s): s | tostring; map(.name + "," + s(.focused) + " ") | reduce .[] as $item (""; . + $item)') && python $(dirname $0)/ipc.py -t subscribe workspace | sed -u -e "s/'/\"/g" -e "s/False/false/g" -e "s/True/true/g" | jq --unbuffered -r 'def s(s): s | tostring; map(.name + "," + s(.focused) + " ") | reduce .[] as $item (""; . + $item)')
}


{
    >(calendar) >(volume) >(clock) >(music) >(workspaces) >(power_menu) | while IFS= read -r line; do
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
        POWER*)
            lemon_power=${line#?????}
            ;;
    esac
    bar="%{B${BAR_BG}}%{l}${lemon_ws}%{B$BAR_BG}%{F$BAR_FG}%{c}${lemon_music}%{r}${lemon_vol}${lemon_clock}${lemon_date}${lemon_power}%{B${BAR_BG}}$(prompt_segment "LEFT" ${POWER_BG} ${BAR_BG} ${BAR_FG})"
    echo "${bar}"
done
} | lemonbar -g x${BAR_HEIGHT} -f "${FONT1}" -f "${FONT2}" -f "${FONT3}" -u 2 -o "${FONT1_OFFSET}" -o "${FONT2_OFFSET}" -o "${FONT3_OFFSET}"  -a 400 | sh
