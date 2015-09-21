BG="#1A1A1A"
FG="#ADADAD"
FOC_FG="#2C3E50"
FOC_BG="#3498DB"
ACT_FG="#3498DB"
ACT_BG="#2C3E50"
MUSIC_FG=${FOC_FG}
MUSIC_BG="#A52A2A"
DATE_FG=${FG}
DATE_BG=${BG}
DATE_ICON_FG=${ACT_FG}
TIME_FG=${DATE_FG}
TIME_BG=${BG}
TIME_ICON_FG=${DATE_ICON_FG}
VOL_FG=${DATE_FG}
VOL_BG=${DATE_BG}
VOL_ICON_FG=${DATE_ICON_FG}
WIFI_FG=${DATE_FG}
WIFI_BG=${DATE_BG}
WIFI_ICON_FG=${DATE_ICON_FG}
MOD_FG=${MUSIC_FG}
MOD_BG=${MUSIC_BG}

SEP_R=""
SEP_L=""
SEP_R_L=""
SEP_L_L=""

PLAY_ICON=""
PAUSE_ICON=""
CALENDAR_ICON=""
TIME_ICON=""
VOL_UP_ICON=""
VOL_DOWN_ICON=""
VOL_OFF_ICON=""
WIFI_ICON=""


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
                    ;;
                "[paused]"*)
                    contents="${PAUSE_ICON} ${data#????????}"
                    ;;
                *)
                    contents="No MPD Connection"
                    ;;
            esac
            music="%{B${MUSIC_BG}}%{F${BG}}${SEP_R} %{F${MUSIC_FG}}%{B${MUSIC_BG}}${contents} %{F${BG}}%{B${MUSIC_BG}}${SEP_L}"
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
            date="%{F${DATE_ICON_FG}}%{B${BG}} ${CALENDAR_ICON} %{F${DATE_FG}}${line#????} "
            ;;
        MOD*)
            mode=""
            if [ "${line#???}" != "default" ]; then
                translated=$(echo "${line#???}" | sed "s/,/ ${SEP_R_L}/g")
                mode="%{R}%{B${MOD_BG}}${SEP_R}%{F${MOD_FG}} ${translated} "
            fi 
            ;;
        WSP*)
            wsp="%{F${BG}}"
            draw=${SEP_R}
            line="$(echo $line | sed "s/[0-9]*://g")"
            set -- ${line#???}
            while [ $# -gt 0 ] ; do
                case $1 in
                    FOC*)
                        [ "${draw}" == "${SEP_R}" ] && fore=${BG} || fore=${FOC_FG}
                        wsp="${wsp}%{F${fore}}%{B${FOC_BG}}${SEP_R}%{F${FOC_FG}} ${1#???}%{F${FOC_BG}}${SEP_R}"
                        draw=${SEP_R}
                        ;;
                    INA*|ACT*|URG*)
                        wsp="${wsp}%{B${ACT_BG}}${draw}%{F${ACT_FG}} ${1#???} "
                        draw="${SEP_R_L}"
                        ;;
                esac
                shift
            done
            ;;
    esac
    echo "%{l}${wsp}${mode}%{R}%{B${BG}}${SEP_R}%{c}${music}%{r}%{B${BG}}${wifi}${vol}${time}${date}"
done
