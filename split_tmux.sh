#!/bin/sh

# split tmux window to number of hosts listed in a file and ssh to them

tmux -S ~/.tmux_socket/default new-session -s "mySession" -d
while getopts ":f:n:" cmd_args; do 
  case $cmd_args in
     n ) number_of_hosts=$OPTARG
       ;;
     f ) hosts_file=$OPTARG
       ;;
    \? ) echo "Invalid option: $OPTARG" 1>&2
       ;;
     : ) echo "Invalid option: $OPTARG requires an argument" 1>&2
       ;; 
  esac
  shift $((OPTIND -1))
done

echo $hosts_file
[ -z "$hosts_file" ] && echo "file contain host(s) is require...ie '-f hosts.txt'" && exit 1

hosts_count=$(cat $hosts_file |wc -l)

pane_count=`tmux -S ~/.tmux_socket/default list-panes |wc -l`
if [ $pane_count -lt $hosts_count ]; then
   pane_to_create=`expr $hosts_count - $pane_count`
   for i in `eval echo {1..${pane_to_create}}`; do
     [ $pane_count -ge $hosts_count ] && break
     largest_pane=`tmux -S ~/.tmux_socket/default list-panes | sed s/:// | sed s/"\["// | sed s/"\]"// | sed s/"x"/" "/ | sort -h -k3 -r | awk '{print $1}' | head -1`
     tmux -S ~/.tmux_socket/default attach -t:.$largest_pane \; split-window -v \; detach
     pane_count=`tmux -S ~/.tmux_socket/default list-panes |wc -l`
   done
fi
tmux -S ~/.tmux_socket/default select-layout tiled
[ -z "$number_of_hosts" ] && number_of_hosts=$hosts_count
set -- `tail -$number_of_hosts $hosts_file`
for i in $(tmux -S ~/.tmux_socket/default list-panes -F '#P'); do
   tmux -S ~/.tmux_socket/default send-keys -t $i "ssh ubuntu@$1 $cmd" Enter
   shift
done
tmux -S ~/.tmux_socket/default attach
