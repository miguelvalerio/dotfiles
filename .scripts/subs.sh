#!/bin/sh
sub="$(subliminal download -l en $1 -v -f | tail -n1 | awk '{print $NF}')"
mpv $1 --sub-file="$(dirname $1)/${sub%.*}.en.srt"
