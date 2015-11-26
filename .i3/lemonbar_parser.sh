#!/bin/bash

. $(dirname $0)/lemonbar_config

while read -r line; do
    case $line in
        SSID*)
            wifi="%{B${WIFI_BG}}%{F${WIFI_ICON_FG}}${WIFI_ICON} %{F${WIFI_FG}}${line#????} "
            ;;
        MUS*)
            data=${line#???}
            case $data in
                "[playing]"*)
                    contents="${PLAY_ICON} ${data#?????????}"
                    play_pause="pause"
                    ;;
                "[paused]"*)
                    contents="${PAUSE_ICON} ${data#????????}"
                    play_pause="play"
                    ;;
                *)
                    contents="No MPD Connection"
                    ;;
            esac
            music="%{A4:mpc next:}%{A5:mpc prev:}%{A:mpc ${play_pause}:}%{B${MUSIC_BG}}%{F${BAR_BG}}${SEP_R} %{F${MUSIC_FG}}%{B${MUSIC_BG}}${contents} %{F${BAR_BG}}%{B${MUSIC_BG}}${SEP_L}%{A}%{A}%{A}"
            ;;
        VOL*)
            volume=${line#???}
            if [ "${volume}" -ge 50 ]; then
                vol_icon=${VOL_UP_ICON}
            elif [ "${volume}" -gt 0 ]; then
                vol_icon=${VOL_DOWN_ICON}
            else
                vol_icon=${VOL_OFF_ICON}
            fi
            vol="%{A4:amixer set Master 5%+:}%{A5:amixer set Master 5%-:}%{B${VOL_BG}}%{F${VOL_ICON_FG}} ${vol_icon} %{F${VOL_FG}}${volume}%{A}%{A} "
            ;;
        TIME*)
            time="%{F${TIME_ICON_FG}}%{B${TIME_BG}} ${TIME_ICON} %{F${TIME_FG}}${line#????} "
            ;;
        DATE*)
            date="%{F${DATE_ICON_FG}}%{B${DATE_BG}} ${CALENDAR_ICON} %{F${DATE_FG}}${line#????} "
            ;;
        MOD*)
            mode=""
            if [ "${line#???}" != "default" ]; then
                translated=$(echo "${line#???}" | sed "s/,/ ${SEP_R_L}/g")
                mode="%{R}%{B${MOD_BG}}${SEP_R}%{F${MOD_FG}} ${translated} "
            fi 
            ;;
        WSP*)
            wsp="%{F${BAR_BG}}"
            # draw=${SEP_R}
            monitor=${line:3:1}
            set -- ${line#????}
            while [ $# -gt 0 ] ; do
                ws_icon="$(echo ${1#???} | sed 's/[0-9]*-//g')"
                case $1 in
                    FOC*)
                        # [ "${draw}" == "${SEP_R}" ] && fore=${BAR_BG} || fore=${ACT_BG}
                        fore=${BAR_BG}
                        ws="%{F${FOC_FG}}%{B${FOC_BG}}${SEP_R}%{F${FOC_FG}} ${ws_icon}%{F${FOC_BG}}${SEP_R}"
                        [ "$POWERLINE_MODE" = false ] && ws="${ws} "
                        [ "$UNDERLINE_MODE" = true ] && ws="%{+uU${UNDERLINE}}${ws}%{-u}"
                        [ "$CLICK_MODE" = true ] && ws="%{A1:i3-msg workspace back_and_forth:}${ws}%{A}"
                        wsp="${wsp}${ws}"
                        draw=${SEP_R}
                        ;;
                    INA*|ACT*|URG*)
                        ws="%{B${ACT_BG}}${draw}%{F${ACT_FG}} ${ws_icon} "
                        [ "$POWERLINE_MODE" = false ] && ws="${ws} "
                        [ "$CLICK_MODE" = true ] && ws="%{A1:i3-msg workspace ${1#???}:}${ws}%{A}"
                        wsp="${wsp}${ws}"
                        draw="${SEP_R_L}"
                        ;;
                esac
                shift
            done
            monitors[${monitor}]=${wsp}
            ;;
    esac
    output=""
    for mon in ${!monitors[@]}; do
        if [ $mon -eq 0 ]; then
            output="${output}%{S}}%{l}${monitors[$mon]}${mode}%{R}%{B${BAR_BG}}${SEP_R}%{c}%{B${BAR_BG}}${music}%{r}${vol}${time}${date}%{B${BAR_BG}}"
        else
            output="${output}%{S+}}%{l}${monitors[$mon]}${mode}%{R}%{B${BAR_BG}}${SEP_R}%{c}%{B${BAR_BG}}${music}%{r}${vol}${time}${date}%{B${BAR_BG}}"
        fi
    done
    echo "$output"
done
