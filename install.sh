#!/usr/bin/env bash
# Symlinks every file under home/ into the matching path in $HOME.
# Idempotent: safe to re-run. Real files at target paths are backed up
# to ~/.dotfiles-backup-<date>/ before being replaced.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_SRC="$REPO_ROOT/home"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y-%m-%d)"
DRY_RUN=0

for arg in "$@"; do
  case "$arg" in
    -n|--dry-run) DRY_RUN=1 ;;
    -h|--help) echo "Usage: $0 [--dry-run]"; exit 0 ;;
    *) echo "Unknown arg: $arg" >&2; exit 2 ;;
  esac
done

[ -d "$HOME_SRC" ] || { echo "No home/ dir in $REPO_ROOT" >&2; exit 1; }

linked=0; already=0; backed_up=0; replaced=0

run() { [ "$DRY_RUN" -eq 1 ] || "$@"; }

link_one() {
  local src="$1" dst="$2"

  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    printf '  ok      %s\n' "$dst"
    already=$((already+1))
    return
  fi

  if [ -L "$dst" ]; then
    printf '  replace %s (was -> %s)\n' "$dst" "$(readlink "$dst")"
    run rm "$dst"
    replaced=$((replaced+1))
  elif [ -e "$dst" ]; then
    if cmp -s "$src" "$dst"; then
      printf '  same    %s (matches source; replacing without backup)\n' "$dst"
      run rm "$dst"
    else
      local rel="${dst#"$HOME"/}"
      local backup="$BACKUP_DIR/$rel"
      printf '  backup  %s -> %s\n' "$dst" "$backup"
      run mkdir -p "$(dirname "$backup")"
      run mv "$dst" "$backup"
      backed_up=$((backed_up+1))
    fi
  fi

  printf '  link    %s -> %s\n' "$dst" "$src"
  run mkdir -p "$(dirname "$dst")"
  run ln -s "$src" "$dst"
  linked=$((linked+1))
}

echo "==> Linking $HOME_SRC into $HOME"
if [ "$DRY_RUN" -eq 1 ]; then echo "    (dry run -- nothing will change)"; fi
echo

while IFS= read -r -d '' src; do
  rel="${src#"$HOME_SRC"/}"
  link_one "$src" "$HOME/$rel"
done < <(find "$HOME_SRC" -type f -print0)

echo
echo "Summary: $linked linked ($already already correct), $replaced replaced, $backed_up backed up"
if [ "$backed_up" -gt 0 ]; then echo "Backups in: $BACKUP_DIR"; fi
