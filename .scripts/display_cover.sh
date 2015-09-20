#!/bin/sh

while :; do
    [ -e /tmp/cover ] && break
    wait 1
done
feh --geometry 300x300 --zoom fill --reload 1 /tmp/cover
