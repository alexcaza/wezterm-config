#!/usr/bin/env bash

set -eo pipefail

while getopts c: flag
do
    case "${flag}" in
        c) config=${OPTARG};;
    esac
done

run_command() {
    local pane_id
    local command_to_run
    pane_id="$1"
    command_to_run="$2"

    # https://github.com/wez/wezterm/discussions/2202#discussioncomment-3052321
    echo -e "$command_to_run" | wezterm cli send-text --no-paste --pane-id "$pane_id"
}

CONFIG_DATA=$(cat $config)
NAME=$(cat $config | jq -cr '.["name"]')
CWD=$(cat $config | jq -cr '.["cwd"]')
LAYOUT=$(cat $config | jq -cr '.["layout"]')
COMMANDS=$(cat $config | jq -cr '.["commands"][]')


main_pane=$(wezterm cli spawn --cwd "$CWD")

# Set tab name
wezterm cli set-tab-title $NAME --pane-id $main_pane

panes=($main_pane)
num_commands=$(echo $CONFIG_DATA | jq '.["commands"] | length')

# Custom ceil calc; removes 2 since main pane is
# already generated. h_splits should gen normal amount
v_splits=$(((( $num_commands + 2 - 1 ) / 2 ) -2))
h_splits=$((( $num_commands + 2 - 1 ) / 2 ))

# Make vertical panes
for i in $(seq $v_splits)
do
    if [ $i -eq 1 ]
    then
        pane=$(wezterm cli split-pane --right --pane-id $main_pane)
        panes+=("$pane")     
    fi
done

# Make horizontal panes
for i in $(seq $h_splits)
do
    pane_to_use=${panes[i-1]}
    pane=$(wezterm cli split-pane --bottom --pane-id $pane_to_use)
    panes+=("$pane")     
done


# Run commands in panes
iter=0
echo $CONFIG_DATA | jq -cr '.["commands"][]' | while read command;
do
    pane=${panes[iter]}
    run_command "$pane" "$command"
    iter=$(($iter + 1))
done
