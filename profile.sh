# for login shells

# fix TERM for ghostty and su
current="$(id -un)"
login_name="$(logname 2>/dev/null || echo "")"
if [ "$login_name" != "$current" ]; then
  if [ "${TERM:-}" = "xterm-ghostty" ]; then
    export TERM="xterm-256color"
    >&2 echo "⚠️  Reset TERM to $TERM (no utmp record detected)"
  fi
fi

# load homebrew
if [ -x /opt/homebrew/bin/brew ]; then
 	eval $(/opt/homebrew/bin/brew shellenv)
else
	echo "homebrew not found" >&2
fi

# add local bin to PATH
LOCAL_BIN="$HOME/.local/bin"
if [ -d "$LOCAL_BIN" ]; then
  case ":$PATH:" in
    *":$LOCAL_BIN:"*) ;;           # already in PATH
    *) PATH="$LOCAL_BIN:$PATH" ;;  # prepend
  esac
  export PATH
fi
export LOCAL_BIN
export PROJECTS="$HOME/projects"  
export GOBIN="$LOCAL_BIN"
export DOTFILES="$HOME/dotfiles"

# set nvim as default editor
if command -v nvim >/dev/null 2>&1; then
  export EDITOR=nvim
  export VISUAL=nvim
fi

echo "👋 profile loaded"
if [[ $- == *i* ]]; then
  # detect bash or zsh (allow for leading dash in login shells)
  case "${0##*/}" in
    *bash)  [[ -f "$HOME/.bashrc" ]] && source "$HOME/.bashrc" ;;
    *zsh)  [[ -f "$HOME/.zshrc" ]] && source "$HOME/.zshrc" ;;
    *)     return   ;;  # not bash or zsh, do nothing
  esac
  echo "👋 interactive shell loaded"
fi