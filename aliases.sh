
alias v=nvim
alias vi=nvim
alias vim=nvim
alias l="ls -CF"
alias la="ls -A"
alias ll="ls -lh"
alias lal="ls -Alh"
alias ..="cd .."
alias ...="cd ../.."
alias ~="cd ~"
alias -- -="cd -"
alias please='sudo $(history -p !!)'  # re-run last command with sudo
alias path='echo -e ${PATH//:/\\n}'

gd() { mkdir -p -- "$@" && cd -- "$@[-1]"; }

if [[ -d "$HOME/projects" ]]; then

  cdp() {
    local pattern="$1" dir
    local findargs=(\
  "$HOME/projects" -mindepth 1 -maxdepth 3 \
  \( -path '*/.*' -o -path '*/node_modules' \) -prune \
  -o -type d
    )
    [ -n "$pattern" ] && findargs+=( -iname "*$pattern*" )
    findargs+=( -exec test -f '{}/.gitignore' ';' -print0 )
    dir=$(find "${findargs[@]}" \
      | fzf --read0 --height 40% --reverse \
              --prompt="Select project> ")
    [ -n "$dir" ] && cd -- "$dir"
  }

fi