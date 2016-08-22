#!/bin/bash

# Dependencies: imagemagick, i3lock-color-git, scrot

IMAGE=/tmp/i3lock.png
ICON=lock_resize.png
HUE=(-level 0%,100%,0.6)
EFFECT=(-filter Gaussian -resize 20% -define filter:sigma=1.5 -resize 500.5%)

TEXT="Type password to unlock"

VALUE="60" #brightness value to compare to
scrot  -z "$IMAGE"
COLOR=$(convert "$IMAGE" -gravity center -crop 100x100+0+0 +repage -colorspace hsb \
    -resize 1x1 txt:- | awk -F '[%$]' 'NR==2{gsub(",",""); printf "%.0f\n", $(NF-1)}');
if [ "$COLOR" -gt "$VALUE" ]; then #white background image and black text
    BW="black"
    PARAM=(--textcolor=00000000 --insidecolor=0000001c --ringcolor=0000003e \
        --linecolor=00000000 --keyhlcolor=ffffff80 --ringvercolor=ffffff00 \
        --separatorcolor=22222260 --insidevercolor=ffffff1c \
        --ringwrongcolor=ffffff55 --insidewrongcolor=ffffff1c)
else #black
    BW="white"
    PARAM=(--textcolor=ffffff00 --insidecolor=ffffff1c --ringcolor=ffffff3e \
        --linecolor=ffffff00 --keyhlcolor=00000080 --ringvercolor=00000000 \
        --separatorcolor=22222260 --insidevercolor=0000001c \
        --ringwrongcolor=00000055 --insidewrongcolor=0000001c)
fi

convert "$IMAGE" "${HUE[@]}" "${EFFECT[@]}" -pointsize 26 -fill "$BW" -gravity center -font Liberation-Sans -annotate +0+160 "$TEXT" "$ICON" -gravity center -composite "$IMAGE"

# try to use a forked version of i3lock with prepared parameters
if ! i3lock -n "${PARAM[@]}" -i "$IMAGE" > /dev/null 2>&1; then
    # We have failed, lets get back to stock one
    i3lock -n -i "$IMAGE"
fi

rm $IMAGE
