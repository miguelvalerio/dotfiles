#!/bin/sh

NO_COVER=$(dirname $0)/no_cover.jpg

while :; do
    current_file=$(mpc current -f %file%)
    current_album=$(dirname "${current_file}")
    music_directory=$(cat ${HOME}/.config/mpd/mpd.conf | grep music_directory | awk '{print $2}' | sed 's/\"//g' )
    album_directory="$music_directory/$current_album"
    album_directory=${album_directory//\~/$HOME}
    album_cover=$(ls "$album_directory" | grep "\.jpg\|\.png")
    [ -z "${album_cover}" ] && cover=${NO_COVER} || cover=${album_directory}/${album_cover}
    ln -f -s "$cover" /tmp/cover
    sleep 2
done
