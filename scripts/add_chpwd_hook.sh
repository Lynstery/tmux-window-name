#!/bin/sh

ZSHRC="$HOME/.zshrc"

BLOCK='# hook for tmux-window-name
tmux-window-name() {
  if [[ -n $TMUX_PLUGIN_MANAGER_PATH ]] then
  (uv run --quiet $TMUX_PLUGIN_MANAGER_PATH/tmux-window-name/scripts/rename_session_windows.py &)
  fi
}
add-zsh-hook chpwd tmux-window-name'

[ -f "$ZSHRC" ] || touch "$ZSHRC"

if grep -Fxq "# hook for tmux-window-name" "$ZSHRC"; then
  echo "already added to $ZSHRC"
else
  printf "\n%s\n" "$BLOCK" >> "$ZSHRC"
  echo "sucessfully added to $ZSHRC"
fi
