#!/usr/bin/env bash

set -eo pipefail

PROJECT_DIR="$HOME/Documents/programming/unsplash-web"
TAB_NAME="unsplash-web"
ENV="development"

run_command() {
    local pane_id
    local command_to_run
    pane_id="$1"
    command_to_run="$2"

    # https://github.com/wez/wezterm/discussions/2202#discussioncomment-3052321
    echo -e "$command_to_run" | wezterm cli send-text --no-paste --pane-id "$pane_id"
}

# Creates panes
main_pane=$(wezterm cli spawn --cwd "$PROJECT_DIR")
second_pane=$(wezterm cli split-pane --right --pane-id "$main_pane")
third_pane=$(wezterm cli split-pane --bottom --pane-id "$main_pane")
fourth_pane=$(wezterm cli split-pane --bottom --pane-id "$second_pane")
fifth_pane=$(wezterm cli split-pane --bottom --pane-id "$main_pane" --top-level --percent 25)

# Rename tab
run_command "$main_pane" "wezterm cli set-tab-title $(echo $TAB_NAME)"

echo "TEST"

# Starts commands
run_command "$main_pane" "nix develop -c just localization-watch-postpone"
run_command "$second_pane" "NODE_ENV=$ENV nix develop -c just server-start-debug" # HACK: Temp until watchexec bug figured out
run_command "$third_pane" "NODE_ENV=$ENV nix develop -c just server-build"
run_command "$fourth_pane" "NODE_ENV=$ENV nix develop -c just client-dev-server"
run_command "$fifth_pane" "NODE_ENV=$ENV nix develop -c just typecheck-watch-all"

