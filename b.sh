#!/bin/sh
tmux new-session \; split-window -v \; rename-window ${1} \; attach
