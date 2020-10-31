#!/bin/sh
tmux new-session -s "mySession" -d
#tmux attach \; split-window -h \; detach
pc=`expr $1 - 1`
v=`expr $pc / 2 `
for i in `eval echo {0..${1}}`; do
  c=`tmux list-panes |wc -l`
  [ $c -ge $1 ] || [ $i -ge $v ] &&  break
  p=`tmux list-panes | sed s/:// | sed s/"\["// | sed s/"\]"// | sed s/"x"/" "/ | sort -h -k2 -r | awk '{print $1}' | head -1`
  tmux attach -t:.$p \; split-window -h \; detach
done

for i in `eval echo {0..${v}}`; do
  [ $c -ge $1 ] && break
  p=`tmux list-panes | sed s/:// | sed s/"\["// | sed s/"\]"// | sed s/"x"/" "/ | sort -h -k3 -r | awk '{print $1}' | head -1`
  tmux attach -t:.$p \; split-window -v \; detach
done
tmux attach
