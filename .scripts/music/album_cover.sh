#!/bin/sh

NO_COVER=$(dirname $0)/no_cover.jpg
TEMP_COVERS=/tmp/spotify_covers
d=$(dirname $0)

[ -d "$TEMP_COVERS" ] || mkdir "$TEMP_COVERS"
ln -fsr $NO_COVER /tmp/cover

# prev_album=""
# while :; do
#     curr_album=$(mpc current -f %album%)
#     if [ "$curr_album" != "$prev_album" ]; then
#         current_file=$(mpc current -f %file%)
#         src=$(echo ${current_file} | awk -F ":" '{print $1}')
#         identifier=$(echo ${current_file} | awk -F ":" '{print $3}' | sed 's/%20/ /g')
#         case $src in
#             spotify*)
#                 cached_cover="$TEMP_COVERS/$curr_album"
#                 if [ ! -f "$cached_cover" ]; then
#                     url="https://api.spotify.com/v1/tracks/${identifier}" 
#                     wget $(curl -X GET ${url} | jq -r ".album.images[0].url") -O "$cached_cover"
#                 fi
#                 cover="$cached_cover"
#                 prev_album="$identifier"
#                 ;;
#             local*)
#                 identifier=$(dirname "${identifier}")
#                 music_directory=$(cat ${HOME}/.config/mpd/mpd.conf | grep music_directory | awk '{print $2}' | sed 's/\"//g' )
#                 album_directory="$music_directory/$identifier"
#                 album_directory=${album_directory//\~/$HOME}
#                 album_cover=$(ls "${album_directory}" | grep "\.jpg\|\.png")
#                 [ -z "${album_cover}" ] && cover=${NO_COVER} || cover=${album_directory}/${album_cover}
#                 ;;
#             *)
#                 cover=${NO_COVER}
#                 ;;
#         esac
#         ln -f -s -r "$cover" /tmp/cover
#         prev_album="$curr_album"
#     fi
#     mpc idle
#     [ ! "$?" -eq 0 ] && sleep 0.5
# done

#MOPIDY
# 
prev_album=""
 while :; do
     mpc idle
     curr_album=$(mpc current -f %album%)
     if [ "$curr_album" != "$prev_album" ]; then
         current_file=$(mpc current -f %file%)
         current_file=${current_file##*:}
         identifier=$(dirname "${current_file}")
         identifier=${identifier//%20/ }
         music_directory=$(cat ${HOME}/.config/mopidy/mopidy.conf | grep media_dir | awk '{print $3}' | sed 's/\"//g' )
         album_directory="$music_directory/$identifier"
         album_directory=${album_directory//\~/$HOME}
         album_cover=$(ls "$album_directory" | grep "\.jpg\|\.png")
         [ -z "${album_cover}" ] && cover=${NO_COVER} || cover=${album_directory}/${album_cover}
         ln -f -s "$cover" /tmp/cover
         prev_album="$curr_album"
     fi
 done
