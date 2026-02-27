#!/usr/bin/env bash

tcl() {
  [[ -z $TMUX ]] && { echo "You must start tmux to use tcl."; return 1; }

  local current_dir="${PWD}"
  local bottom_pane top_left_pane top_right_pane

  bottom_pane="$TMUX_PANE"

  tmux rename-window -t "$bottom_pane" "$(basename "$current_dir")"

  # Top = 55%, Bottom = 45%
  top_left_pane=$(tmux split-window -v -b -p 60 -t "$bottom_pane" -c "$current_dir" -P -F '#{pane_id}' "bash -lc 'yazi; exec bash -l'")
  top_right_pane=$(tmux split-window -h -p 30 -t "$top_left_pane" -c "$current_dir" -P -F '#{pane_id}' "bash -lc 'opencode; exec bash -l'")

  # Bottom pane: plain terminal unless current dir is a git repo
  if git -C "$current_dir" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    tmux respawn-pane -k -t "$bottom_pane" -c "$current_dir" "bash -lc 'lazygit; exec bash -l'"
  fi

  tmux select-pane -t "$top_left_pane"
}
