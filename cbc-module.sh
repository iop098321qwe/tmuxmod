#!/usr/bin/env bash

# tcl() {
#   [[ -z $TMUX ]] && { echo "You must start tmux to use tcl."; return 1; }
#
#   local current_dir="${PWD}"
#   local file_pane ai_pane
#
#   file_pane="$TMUX_PANE"
#
#   tmux rename-window -t "$file_pane" "$(basename "$current_dir")"
#   tmux split-window -v -p 45 -t "$file_pane" -c "$current_dir"
#   ai_pane=$(tmux split-window -h -p 30 -t "$file_pane" -c "$current_dir" -P -F '#{pane_id}')
#
#   tmux send-keys -t "$file_pane" "yazi" C-m
#   tmux send-keys -t "$ai_pane" "opencode" C-m
#
#   tmux select-pane -t "$file_pane"
# }

# tcl() {
#   [[ -z $TMUX ]] && { echo "You must start tmux to use tcl."; return 1; }
#   local current_dir="${PWD}"
#   local bottom_pane top_left_pane
#   bottom_pane="$TMUX_PANE"
#   tmux rename-window -t "$bottom_pane" "$(basename "$current_dir")"
#   # Create top pane at 55% (with -b), leaving bottom at 45%
#   top_left_pane=$(tmux split-window -v -b -p 55 -t "$bottom_pane" -c "$current_dir" -P -F '#{pane_id}')
#   # Top-right pane: start opencode directly
#   tmux split-window -h -p 30 -t "$top_left_pane" -c "$current_dir" \
#     "bash -lc 'opencode; exec bash -l'"
#   # Top-left pane: start yazi directly (clean launch, no send-keys)
#   tmux respawn-pane -k -t "$top_left_pane" -c "$current_dir" \
#     "bash -lc 'yazi; exec bash -l'"
#   tmux select-pane -t "$top_left_pane"
# }

# tcl() {
#   [[ -z $TMUX ]] && { echo "You must start tmux to use tcl."; return 1; }
#   local current_dir="${PWD}"
#   local bottom_left_pane top_left_pane top_right_pane
#   bottom_left_pane="$TMUX_PANE"
#   tmux rename-window -t "$bottom_left_pane" "$(basename "$current_dir")"
#   top_left_pane=$(tmux split-window -v -b -p 55 -t "$bottom_left_pane" -c "$current_dir" -P -F '#{pane_id}')
#   top_right_pane=$(tmux split-window -h -p 30 -t "$top_left_pane" -c "$current_dir" -P -F '#{pane_id}')
#   tmux split-window -h -p 50 -t "$bottom_left_pane" -c "$current_dir"
#   tmux respawn-pane -k -t "$top_left_pane" -c "$current_dir" "bash -lc 'yazi; exec bash -l'"
#   tmux respawn-pane -k -t "$top_right_pane" -c "$current_dir" "bash -lc 'opencode; exec bash -l'"
#   tmux respawn-pane -k -t "$bottom_left_pane" -c "$current_dir" "bash -lc 'lazygit; exec bash -l'"
#   tmux select-pane -t "$top_left_pane"
# }

# tcl() {
#   [[ -z $TMUX ]] && { echo "You must start tmux to use tcl."; return 1; }
#   local current_dir="${PWD}"
#   local bottom_left_pane top_left_pane top_right_pane
#   bottom_left_pane="$TMUX_PANE"
#   tmux rename-window -t "$bottom_left_pane" "$(basename "$current_dir")"
#   # Top = 55%, Bottom = 45%
#   top_left_pane=$(tmux split-window -v -b -p 55 -t "$bottom_left_pane" -c "$current_dir" -P -F '#{pane_id}')
#   # Top-right = 30% of top region
#   top_right_pane=$(tmux split-window -h -p 30 -t "$top_left_pane" -c "$current_dir" -P -F '#{pane_id}')
#   # If this is a git repo, split bottom 50/50 and run lazygit in bottom-left.
#   # Otherwise, keep the 3-pane layout with bottom as a plain terminal.
#   if git -C "$current_dir" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
#     tmux split-window -h -p 50 -t "$bottom_left_pane" -c "$current_dir"
#     tmux respawn-pane -k -t "$bottom_left_pane" -c "$current_dir" "bash -lc 'lazygit; exec bash -l'"
#   fi
#   tmux respawn-pane -k -t "$top_left_pane" -c "$current_dir" "bash -lc 'yazi; exec bash -l'"
#   tmux respawn-pane -k -t "$top_right_pane" -c "$current_dir" "bash -lc 'opencode; exec bash -l'"
#   tmux select-pane -t "$top_left_pane"
# }

# tcl() {
#   [[ -z $TMUX ]] && { echo "You must start tmux to use tcl."; return 1; }
#   local current_dir="${PWD}"
#   local bottom_right_pane top_left_pane top_right_pane bottom_left_pane
#   bottom_right_pane="$TMUX_PANE"
#   tmux rename-window -t "$bottom_right_pane" "$(basename "$current_dir")"
#   # Top area 55%, bottom area 45%
#   top_left_pane=$(tmux split-window -v -b -p 55 -t "$bottom_right_pane" -c "$current_dir" -P -F '#{pane_id}' "bash -lc 'yazi; exec bash -l'")
#   top_right_pane=$(tmux split-window -h -p 30 -t "$top_left_pane" -c "$current_dir" -P -F '#{pane_id}' "bash -lc 'opencode; exec bash -l'")
#   # Only add lazygit pane when current dir is a git repo
#   if git -C "$current_dir" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
#     bottom_left_pane=$(tmux split-window -h -b -p 50 -t "$bottom_right_pane" -c "$current_dir" -P -F '#{pane_id}' "bash -lc 'lazygit; exec bash -l'")
#   fi
#   # Keep focus on yazi (top-left)
#   tmux select-pane -t "$top_left_pane"
# }

tcl() {
  [[ -z $TMUX ]] && { echo "You must start tmux to use tcl."; return 1; }
  local current_dir="${PWD}"
  local bottom_pane top_left_pane top_right_pane
  bottom_pane="$TMUX_PANE"
  tmux rename-window -t "$bottom_pane" "$(basename "$current_dir")"
  # Top = 55%, Bottom = 45%
  top_left_pane=$(tmux split-window -v -b -p 55 -t "$bottom_pane" -c "$current_dir" -P -F '#{pane_id}' "bash -lc 'yazi; exec bash -l'")
  top_right_pane=$(tmux split-window -h -p 30 -t "$top_left_pane" -c "$current_dir" -P -F '#{pane_id}' "bash -lc 'opencode; exec bash -l'")
  # Bottom pane: plain terminal unless current dir is a git repo
  if git -C "$current_dir" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    tmux respawn-pane -k -t "$bottom_pane" -c "$current_dir" "bash -lc 'lazygit; exec bash -l'"
  fi
  tmux select-pane -t "$top_left_pane"
}
