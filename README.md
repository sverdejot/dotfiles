# sverdejot dotfiles

Managed with [chezmoi](https://chezmoi.io).

## New machine

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply sverdejot
```

This installs Homebrew, the `Brewfile`, mise tools, tmux plugins and applies macOS defaults.

## Daily use

| Task | Command |
|---|---|
| edit a file | `chezmoi edit ~/.zshrc` (or edit in place, then `chezmoi re-add`) |
| see pending changes | `chezmoi diff` |
| apply repo -> home | `chezmoi apply` |
| pull + apply | `chezmoi update` |
| go to repo | `chezmoi cd` |

## Secrets

Never commit secrets. They are read at runtime from the macOS Keychain
(see `GEEMAIL_API_CREDENTIALS` in `.zshrc`).
