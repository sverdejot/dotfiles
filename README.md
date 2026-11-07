# dotfiles

macOS setup: zsh (antidote), git, neovim, tmux, ghostty, yabai + skhd, mise, atuin, starship and Claude Code.

## Install

```sh
git clone git@github.com:sverdejot/dotfiles.git ~/repos/personal/dotfiles
~/repos/personal/dotfiles/install.sh
```

Installs Homebrew + `Brewfile`, symlinks every folder to its place, installs mise tools and tmux plugins, merges Claude settings and applies macOS defaults.
Existing files are moved to `*.bak.<timestamp>`, never deleted.

## Layout

Each folder is linked as-is, so editing `~/.config/nvim` edits this repo.

| Repo | Linked to |
|---|---|
| `zsh/zshrc`, `zsh/zshenv` | `~/.zshrc`, `~/.zshenv` |
| `zsh/`, `git/`, `nvim/`, `tmux/`, `ghostty/`, `yabai/`, `skhd/`, `mise/` | `~/.config/<name>` |
| `atuin/config.toml`, `starship.toml` | `~/.config/...` |
| `claude/` | `~/.claude/` (CLAUDE.md, RTK.md, hooks, commands, skills) |
| `Brewfile` | apps and system tools (dev CLIs live in `mise/config.toml`) |

## Claude settings

`~/.claude/settings.json` is **not** linked: Claude Code writes machine-specific data to it (`autoMode`).
The repo keeps `claude/settings.base.json` instead.

```sh
./install.sh claude-save   # local settings -> repo (drops local-only keys)
./install.sh claude        # repo -> local settings (merge)
```

## Secrets

Never committed. Read at runtime from the macOS Keychain (see `zsh/zshrc`).
