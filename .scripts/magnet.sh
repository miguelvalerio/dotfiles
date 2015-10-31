#!/bin/bash
test -z $1 && echo "need magnet link!
$0 <magnet link>" && exit -1
 
HOST=127.0.0.1 #YourRemoteHostNameOrIP
PORT=9091 #YourPort(default is 9091)
USER=User
PASS=pass
 
LINK="$1"
# set true if you want every torrent to be paused initially
#PAUSED="true"
PAUSED="false"
SESSID=$(curl --silent --anyauth "http://$HOST:$PORT/transmission/rpc" | sed 's/.*<code>//g;s/<\/code>.*//g')
curl --silent --anyauth --header "$SESSID" "http://$HOST:$PORT/transmission/rpc" -d "{\"method\":\"torrent-add\",\"arguments\":{\"paused\":${PAUSED},\"filename\":\"${LINK}\"}}"
