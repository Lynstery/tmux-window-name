#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

UV_AVAILABLE=$(command -v uv >/dev/null 2>&1 && echo True || echo False)
if [ "$UV_AVAILABLE" = "False" ]; then
    tmux display "ERROR: tmux-window-name - 'uv' not found in PATH"
    exit 0
fi

tmux set -g automatic-rename on # Set automatic-rename on to make #{automatic-rename} be on when a new window is been open without a name
tmux set-hook -g 'after-new-window[8921]' 'set -wF @tmux_window_name_enabled \#\{automatic-rename\} ; set -w automatic-rename off'
tmux set-hook -g 'after-select-window[8921]' "run-shell -b 'uv run --quiet \"$CURRENT_DIR\"/scripts/rename_session_windows.py'"

############################################################################################
### Hacks for preserving users custom window names, read more at enable_user_rename_hook ###
############################################################################################

"$CURRENT_DIR"/scripts/rename_session_windows.py --enable_rename_hook

# Disabling rename hooks when tmux-ressurect restores the sessions
tmux set -g @resurrect-hook-pre-restore-all  "uv run --quiet \"$CURRENT_DIR\"/scripts/rename_session_windows.py --disable_rename_hook"
tmux set -g @resurrect-hook-post-restore-all "uv run --quiet \"$CURRENT_DIR\"/scripts/rename_session_windows.py --post_restore"
