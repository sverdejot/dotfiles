#!/usr/bin/env bash
# Dotfiles installer: symlinks every config in this repo to its place in $HOME.
#
#   ./install.sh            full setup (brew, links, mise, tmux plugins, claude, macos)
#   ./install.sh links      only (re)create symlinks
#   ./install.sh claude     merge claude/settings.base.json into ~/.claude/settings.json
#   ./install.sh claude-save  copy ~/.claude/settings.json back to the repo (minus local keys)
#
# Existing files are never deleted: they are moved to <file>.bak.<timestamp>.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"

# repo path -> target path
LINKS=(
  "zsh/zshrc            $HOME/.zshrc"
  "zsh/zshenv           $HOME/.zshenv"
  "zsh                  $CONFIG/zsh"
  "git                  $CONFIG/git"
  "nvim                 $CONFIG/nvim"
  "tmux                 $CONFIG/tmux"
  "ghostty              $CONFIG/ghostty"
  "yabai                $CONFIG/yabai"
  "skhd                 $CONFIG/skhd"
  "mise                 $CONFIG/mise"
  "atuin/config.toml    $CONFIG/atuin/config.toml"
  "starship.toml        $CONFIG/starship.toml"
  "claude/CLAUDE.md     $HOME/.claude/CLAUDE.md"
  "claude/RTK.md        $HOME/.claude/RTK.md"
  "claude/hooks         $HOME/.claude/hooks"
  "claude/commands      $HOME/.claude/commands"
)
for skill in "$DOTFILES"/claude/skills/*/; do
  name="$(basename "$skill")"
  LINKS+=("claude/skills/$name $HOME/.claude/skills/$name")
done

# Keys in ~/.claude/settings.json that stay local and never reach the repo
CLAUDE_LOCAL_KEYS='del(.autoMode)'

log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }

link() {
  local src="$DOTFILES/$1" dst="$2"
  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    return
  fi
  if [[ -e "$dst" || -L "$dst" ]]; then
    local bak="$dst.bak.$(date +%Y%m%d%H%M%S)"
    mv "$dst" "$bak"
    log "backup $dst -> $bak"
  fi
  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
  log "link   $dst -> $src"
}

links() {
  local entry
  for entry in "${LINKS[@]}"; do
    # shellcheck disable=SC2086
    link $entry
  done
}

brew_bundle() {
  if ! command -v brew >/dev/null && [[ ! -x /opt/homebrew/bin/brew ]]; then
    log "installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  eval "$(/opt/homebrew/bin/brew shellenv)"
  log "brew bundle"
  brew bundle --file="$DOTFILES/Brewfile"
}

mise_install() {
  if [[ ! -x "$HOME/.local/bin/mise" ]] && ! command -v mise >/dev/null; then
    log "installing mise"
    curl -fsSL https://mise.run | sh
  fi
  log "mise install"
  "$HOME/.local/bin/mise" install --yes
}

tmux_plugins() {
  local tpm="$CONFIG/tmux/plugins/tpm"
  [[ -d "$tpm" ]] || git clone --depth 1 https://github.com/tmux-plugins/tpm "$tpm"
  log "tmux plugins"
  "$tpm/bin/install_plugins" >/dev/null || true
}

claude() {
  local base="$DOTFILES/claude/settings.base.json" dst="$HOME/.claude/settings.json"
  mkdir -p "$HOME/.claude"
  if [[ -f "$dst" ]]; then
    jq -s '.[0] * .[1]' "$dst" "$base" > "$dst.tmp" && mv "$dst.tmp" "$dst"
  else
    cp "$base" "$dst"
  fi
  chmod 600 "$dst"
  log "claude settings merged"
}

claude_save() {
  jq "$CLAUDE_LOCAL_KEYS" "$HOME/.claude/settings.json" > "$DOTFILES/claude/settings.base.json"
  log "saved ~/.claude/settings.json -> claude/settings.base.json"
}

macos() {
  log "macOS defaults"
  defaults write NSGlobalDomain InitialKeyRepeat -int 12
  defaults write NSGlobalDomain KeyRepeat -int 1
  yabai --start-service 2>/dev/null || true
  skhd --start-service 2>/dev/null || true
}

case "${1:-all}" in
  all)         brew_bundle; links; mise_install; tmux_plugins; claude; macos ;;
  links)       links ;;
  claude)      claude ;;
  claude-save) claude_save ;;
  *)           sed -n '2,9p' "$0"; exit 1 ;;
esac
