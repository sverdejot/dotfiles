#!/bin/sh
# Install tpm and tmux plugins
set -eu
TPM="$HOME/.config/tmux/plugins/tpm"
[ -d "$TPM" ] || git clone --depth 1 https://github.com/tmux-plugins/tpm "$TPM"
"$TPM/bin/install_plugins" || true
