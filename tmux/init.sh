#!/bin/sh

cat tmux.conf > ~/.tmux/tmux.conf && tmux source-file ~/.tmux/tmux.conf
