#!/bin/sh
sub="$(subliminal download -l en "$1" -v -f | tail -n1 | awk '{print substr($0, index($0, $5))}')"
mpv "$1" --sub-file="$(dirname "$1")/${sub%.*}.en.srt"
