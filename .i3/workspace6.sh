#!/bin/bash

i3-msg 'workspace 6-; append_layout ~/.i3/workspace6_layout.json'
urxvt -hold -title player -e ncmpcpp --screen browser --config ~/.ncmpcpp/alternative &
urxvt -hold -title visualizer -e ncmpcpp &
~/.scripts/display_cover.sh &
