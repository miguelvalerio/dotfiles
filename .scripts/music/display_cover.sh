#!/bin/sh

while :; do
    [ -e /tmp/cover ] && break
    sleep 1
done
feh --geometry 300x300 -Z --zoom fill --reload 1 /tmp/cover
