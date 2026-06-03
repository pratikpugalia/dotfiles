# dotfiles

Personal configuration files, scripts, and tools.

## Layout

```
home/          mirrors $HOME; every file here gets symlinked to the matching path under $HOME
install.sh     creates symlinks idempotently
```

## Install

```sh
git clone https://github.com/pratikpugalia/dotfiles ~/repos/dotfiles
cd ~/repos/dotfiles
./install.sh --dry-run    # preview
./install.sh              # apply
```

Existing files at target paths are moved to `~/.dotfiles-backup-<date>/` before being replaced with symlinks. Re-running is safe; symlinks that already point at the repo are left alone.

## Adding a new dotfile

1. Move the file into `home/` preserving its path relative to `$HOME`
   (e.g. `~/.config/git/ignore` → `home/.config/git/ignore`)
2. Run `./install.sh`

## Tracked

- `home/.zshrc` — zsh interactive config (oh-my-zsh, git aliases, jenv, openclaw completions)
- `home/.claude/skills/` — Claude Code skills
