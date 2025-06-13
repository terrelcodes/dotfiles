#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# 1) Where am I? (the directory containing this script)
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
repo_root="$(cd "$script_dir" && pwd -P)"  # adjust if your script is deeper

# 2) Map source → multiple destinations
#    profile.sh → .zprofile & .bash_profile
#    shrc.sh    → .zshrc    & .bashrc
#    zshenv.zsh → .zshenv    (no bash)
declare -A targets=(
  ["$repo_root/profile.sh"]=".zprofile .bash_profile"
  ["$repo_root/shrc.sh"   ]=".zshrc .bashrc"
  ["$repo_root/zsh/zshenv.zsh"]=".zshenv"
)
backup_files=(
  .bash_login
  .bash_profile
  .bashrc
  .profile
  .zshrc
  .zshenv
)

# 1) create the dir now…
backup_dir="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$backup_dir"

# 2) move any existing dotfiles in
for file in "${backup_files[@]}"; do
  src="$HOME/$file"
  if [ -e "$src" ] || [ -L "$src" ]; then
    echo "⤷ Backing up $src → $backup_dir/$file"
    mv -f "$src" "$backup_dir/$file"
  fi
done

# 3) if it’s empty, remove it; otherwise list its contents
if [ -z "$(ls -A "$backup_dir")" ]; then
  rmdir "$backup_dir"
  echo "No dotfiles to back up; removed empty $backup_dir"
else
  echo
  echo "Backed up dotfiles into: $backup_dir"
fi

# 4) Symlink loop
for src in "${!targets[@]}"; do
  for dest_basename in ${targets[$src]}; do
    dest="$HOME/$dest_basename

    # ensure parent dir exists (usually $HOME)
    mkdir -p "$(dirname "$dest")"

    # create or replace symlink
    ln -sfn "$src" "$dest"
    echo "✔ Linked $dest → $src"
  done
done

echo
echo "Backup of replaced files is in: $backup_dir"