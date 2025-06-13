#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# 1) Where am I?
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
repo_root="$script_dir"   # if this script lives in dotfiles/, adjust if deeper

# 2) What to back up?
backup_files=(
  .bash_login
  .bash_profile
  .bashrc
  .profile
  .zshrc
  .zshenv
)

# 3) Prepare backup dir (we’ll delete it later if it’s empty)
backup_dir="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$backup_dir"

# 4) Move any existing dotfiles into backup
for file in "${backup_files[@]}"; do
  src="$HOME/$file"
  if [ -e "$src" ] || [ -L "$src" ]; then
    echo "⤷ Backing up $src → $backup_dir/$file"
    mv -f "$src" "$backup_dir/$file"
  fi
done

# 5) If backup dir is empty, nuke it
if [ -z "$(ls -A "$backup_dir")" ]; then
  rmdir "$backup_dir"
  echo "No dotfiles found; removed empty $backup_dir"
else
  echo
  echo "Backed up your old dotfiles in: $backup_dir"
fi

# 6) Prepare the *parallel* source/dest‐lists
sources=(
  "$repo_root/profile.sh"
  "$repo_root/shrc.sh"
  "$repo_root/zsh/zshenv.zsh"
)

dest_lists=(
  ".zprofile .bash_profile"
  ".zshrc   .bashrc"
  ".zshenv"
)

# 7) Symlink them
for i in "${!sources[@]}"; do
  src="${sources[i]}"
  for dest_basename in ${dest_lists[i]}; do
    dest="$HOME/$dest_basename"
    mkdir -p "$(dirname "$dest")"
    ln -sfn "$src" "$dest"
    echo "✔ Linked $dest → $src"
  done
done