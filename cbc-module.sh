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

# Apply tcl layout to each subdirectory in the current directory
# Usage: tclm
tclm() {
  [[ -z $TMUX ]] && { echo "You must start tmux to use tclm."; return 1; }

  local base_dir="${PWD}"
  local first=true

  # Rename the session to the current directory name
  tmux rename-session "$(basename "$base_dir" | tr '.:' '--')"

  for dir in "$base_dir"/*/; do
    [[ -d $dir ]] || continue
    local dirpath="${dir%/}"

    if $first; then
      # Reuse the current window for the first project
      tmux send-keys -t "$TMUX_PANE" "cd '$dirpath' && tcl" C-m
      first=false
    else
      local pane_id
      pane_id=$(tmux new-window -c "$dirpath" -P -F '#{pane_id}')
      tmux send-keys -t "$pane_id" "tcl" C-m
    fi
  done
}

# Apply tcl layout to selected subdirectories in the current directory
# Usage: tclf
tclf() {
  [[ -z $TMUX ]] && { echo "You must start tmux to use tclf."; return 1; }

  if ! command -v gum >/dev/null 2>&1; then
    echo "gum is required to use tclf."
    return 1
  fi

  local base_dir="${PWD}"
  local first=true
  local -a dir_names=()
  local -a dir_paths=()

  local dir
  for dir in "$base_dir"/*/; do
    [[ -d $dir ]] || continue
    local dirpath="${dir%/}"
    dir_paths+=("$dirpath")
    dir_names+=("$(basename "$dirpath")")
  done

  if ((${#dir_names[@]} == 0)); then
    echo "No subdirectories found in $base_dir."
    return 0
  fi

  local selected
  local -a selected_dirs=()

  selected=$(printf '%s\n' "${dir_names[@]}" | gum choose --no-limit) || return 0
  [[ -z $selected ]] && return 0

  mapfile -t selected_dirs <<<"$selected"

  # Rename the session to the current directory name
  tmux rename-session "$(basename "$base_dir" | tr '.:' '--')"

  local name
  for name in "${selected_dirs[@]}"; do
    local dirpath=""
    local i
    for i in "${!dir_names[@]}"; do
      if [[ ${dir_names[$i]} == "$name" ]]; then
        dirpath="${dir_paths[$i]}"
        break
      fi
    done

    [[ -z $dirpath ]] && continue

    if $first; then
      # Reuse the current window for the first project
      tmux send-keys -t "$TMUX_PANE" "cd '$dirpath' && tcl" C-m
      first=false
    else
      local pane_id
      pane_id=$(tmux new-window -c "$dirpath" -P -F '#{pane_id}')
      tmux send-keys -t "$pane_id" "tcl" C-m
    fi
  done
}

tal() {
  [[ -z $TMUX ]] && { echo "You must start tmux to use tal."; return 1; }

  local current_dir="${PWD}"
  local left_pane

  left_pane="$TMUX_PANE"

  tmux rename-window -t "$left_pane" "$(basename "$current_dir")"

  tmux split-window -h -p 30 -t "$left_pane" -c "$current_dir" "bash -lc 'opencode; exec bash -l'"
  tmux respawn-pane -k -t "$left_pane" -c "$current_dir" "bash -lc 'yazi; exec bash -l'"

  tmux select-pane -t "$left_pane"
}

# Apply tal layout to each subdirectory in the current directory
# Usage: tslm
talm() {
  [[ -z $TMUX ]] && { echo "You must start tmux to use tslm."; return 1; }

  local base_dir="${PWD}"
  local first=true

  # Rename the session to the current directory name
  tmux rename-session "$(basename "$base_dir" | tr '.:' '--')"

  for dir in "$base_dir"/*/; do
    [[ -d $dir ]] || continue
    local dirpath="${dir%/}"

    if $first; then
      # Reuse the current window for the first project
      tmux send-keys -t "$TMUX_PANE" "cd '$dirpath' && tal" C-m
      first=false
    else
      local pane_id
      pane_id=$(tmux new-window -c "$dirpath" -P -F '#{pane_id}')
      tmux send-keys -t "$pane_id" "tal" C-m
    fi
  done
}

# Apply tal layout to selected subdirectories in the current directory
# Usage: talf
talf() {
  [[ -z $TMUX ]] && { echo "You must start tmux to use talf."; return 1; }

  if ! command -v gum >/dev/null 2>&1; then
    echo "gum is required to use talf."
    return 1
  fi

  local base_dir="${PWD}"
  local first=true
  local -a dir_names=()
  local -a dir_paths=()

  local dir
  for dir in "$base_dir"/*/; do
    [[ -d $dir ]] || continue
    local dirpath="${dir%/}"
    dir_paths+=("$dirpath")
    dir_names+=("$(basename "$dirpath")")
  done

  if ((${#dir_names[@]} == 0)); then
    echo "No subdirectories found in $base_dir."
    return 0
  fi

  local selected
  local -a selected_dirs=()

  selected=$(printf '%s\n' "${dir_names[@]}" | gum choose --no-limit) || return 0
  [[ -z $selected ]] && return 0

  mapfile -t selected_dirs <<<"$selected"

  # Rename the session to the current directory name
  tmux rename-session "$(basename "$base_dir" | tr '.:' '--')"

  local name
  for name in "${selected_dirs[@]}"; do
    local dirpath=""
    local i
    for i in "${!dir_names[@]}"; do
      if [[ ${dir_names[$i]} == "$name" ]]; then
        dirpath="${dir_paths[$i]}"
        break
      fi
    done

    [[ -z $dirpath ]] && continue

    if $first; then
      # Reuse the current window for the first project
      tmux send-keys -t "$TMUX_PANE" "cd '$dirpath' && tal" C-m
      first=false
    else
      local pane_id
      pane_id=$(tmux new-window -c "$dirpath" -P -F '#{pane_id}')
      tmux send-keys -t "$pane_id" "tal" C-m
    fi
  done
}

# Open a new window for selected subdirectory
# Usage: tn [command...]
tn() {
  [[ -z $TMUX ]] && { echo "You must start tmux to use tn."; return 1; }

  if ! command -v gum >/dev/null 2>&1; then
    echo "gum is required to use tn."
    return 1
  fi

  local base_dir="${PWD}"
  local -a dir_names=()
  local -a dir_paths=()

  local dir
  for dir in "$base_dir"/*/; do
    [[ -d $dir ]] || continue
    local dirpath="${dir%/}"
    dir_paths+=("$dirpath")
    dir_names+=("$(basename "$dirpath")")
  done

  if ((${#dir_names[@]} == 0)); then
    echo "No subdirectories found in $base_dir."
    return 0
  fi

  local selected
  selected=$(printf '%s\n' "${dir_names[@]}" | gum choose) || return 0
  [[ -z $selected ]] && return 0

  local target_dir=""
  local i
  for i in "${!dir_names[@]}"; do
    if [[ ${dir_names[$i]} == "$selected" ]]; then
      target_dir="${dir_paths[$i]}"
      break
    fi
  done

  [[ -z $target_dir ]] && return 0

  local pane_id
  pane_id=$(tmux new-window -c "$target_dir" -P -F '#{pane_id}')

  local cmd="$*"
  if [[ -n $cmd ]]; then
    tmux send-keys -t "$pane_id" "$cmd" C-m
  fi
}
