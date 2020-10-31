#!/bin/sh
cmd=$*
np=$(tmux -S /home/pi/.tmux_socket/default list-panes |wc -l)
set -- `tail -$np hosts.txt`
for i in $(tmux -S /home/pi/.tmux_socket/default list-panes -F '#P'); do
   tmux -S /home/pi/.tmux_socket/default send-keys -t $i "ssh ubuntu@$1 $cmd" Enter
   shift
done
