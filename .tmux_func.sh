#!/bin/sh
if [ "$1" = "e" ]
then
#    echo "EEEE"
    width=$(tmux display -p '#{window_width}')
    height=$(tmux display -p '#{window_height}')
    #echo "size = $foo"
    half_width=$(expr $width / 2)
    half_height=$(expr $height / 2)
    #echo $result
    tmux resize-pane -x $half_width
    tmux resize-pane -y $half_height
elif [ "$1" = "f" ]
then
#    echo "FFFF"
    width=$(tmux display -p '#{window_width}')
    height=$(tmux display -p '#{window_height}')
    #echo "size = $foo"
    half_width=$(expr $width \* 3 / 4)
    half_height=$(expr $height \* 3 / 4)
    #echo $result
    tmux resize-pane -x $half_width
    tmux resize-pane -y $half_height
fi
