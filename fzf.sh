# note that if homebrew is not installed, fzf will not be available either
# fzf auto‐completion & key‐bindings (bash & zsh only)
if [[ $- == *i* ]] && [[ -d "$HOMEBREW_PREFIX/opt/fzf/shell" ]]; then
  # strip any leading path components (there usually aren’t any here)
  shell_type=

  # detect bash or zsh (allow for leading dash in login shells)
  case "${0##*/}" in
    *bash) shell_type=bash ;;
    *zsh)  shell_type=zsh  ;;
    *)     return   ;;  # not bash or zsh, do nothing
  esac

  source "$HOMEBREW_PREFIX/opt/fzf/shell/completion.$shell_type"
  source "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.$shell_type"
fi