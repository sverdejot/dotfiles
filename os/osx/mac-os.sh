# increase the default speed of arrow keys
defaults write NSGlobalDomain InitialKeyRepeat -int 12
defaults write NSGlobalDomain KeyRepeat -int 1ac

# install nerd font for proper glyphs on nvim and alacritty
brew tap homebrew/cask-fonts
brew install font-jetbrains-mono-nerd-font
