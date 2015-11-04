#!/bin/bash

i3-msg 'workspace 6-; append_layout ~/.i3/workspace6_layout.json'
urxvt +hold -title visualizer -e ncmpcpp --screen visualizer --config ~/.ncmpcpp/alternative &
urxvt +hold -title player -e ncmpcpp &
~/.scripts/display_cover.sh &
