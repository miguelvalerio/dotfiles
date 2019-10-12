#!/usr/bin/env sh

i3-msg -t subscribe -m '[ "workspace" ]' | while read line ; do
    $(dirname $0)/notify-send.sh --replace=110 "$(i3-msg -t get_workspaces | jq '.[].name')"
    #i3-msg -t get_workspaces | jq '.[].name'
done
