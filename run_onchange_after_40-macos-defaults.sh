#!/bin/sh
# macOS preferences. Edit this file to re-apply.
set -eu
# fast key repeat
defaults write NSGlobalDomain InitialKeyRepeat -int 12
defaults write NSGlobalDomain KeyRepeat -int 1
# start yabai/skhd as login services
yabai --start-service 2>/dev/null || true
skhd --start-service 2>/dev/null || true
