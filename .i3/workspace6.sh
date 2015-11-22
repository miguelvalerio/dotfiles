#!/bin/bash

i3-msg 'workspace 6-; exec urxvt -hold -e "ncmpcpp"'
sleep 0.5
i3-msg 'exec ~/.scripts/display_cover.sh'
sleep 0.5
i3-msg 'focus child'
for i in {1..5} 
do
    i3-msg 'focus child; resize shrink width 10'
done
for i in {1..17} 
do
    i3-msg 'focus child; resize grow width 10 or 1'
done
i3-msg 'focus parent; split v; exec urxvt -hold -e ncmpcpp --screen media_library --config ~/.ncmpcpp/alternative'
sleep 0.5
i3-msg 'workspace 2-'
