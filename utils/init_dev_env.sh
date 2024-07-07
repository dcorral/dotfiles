#!/bin/bash

# Check if running inside a tmux session
if [ -n "$TMUX" ]; then
    SESSION_NAME=$(tmux display-message -p '#S')
else
    echo "You need to run this script from within an existing tmux session."
    exit 1
fi

kill_and_wait() {
    local process_name="$1"

    # Get the process ID(s) of the process
    pids=$(pgrep "$process_name")

    if [ -z "$pids" ]; then
        echo "No $process_name process found."
        return
    fi

    # Kill the process
    echo "Killing $process_name process(es): $pids"
    kill $pids

    # Wait until the process is terminated
    while kill -9 $pids 2>/dev/null; do
        echo "Waiting for $process_name process(es) to terminate..."
        sleep 1
    done

    echo "$process_name process(es) terminated."
}

# Kill bitcoind process and wait
kill_and_wait "bitcoind"

# Kill ord process and wait
kill_and_wait "ord"

# Create the infra window with 4 panes equally sized, ordered clockwise starting from the top left
tmux rename-window -t $SESSION_NAME:1 infra
tmux split-window -h -t $SESSION_NAME:infra
tmux split-window -v -t $SESSION_NAME:infra.1
tmux split-window -v -t $SESSION_NAME:infra.2

# Arrange panes in a 2x2 grid
tmux select-layout -t $SESSION_NAME:infra tiled

# Set the paths for the panes
killall bitcoind
tmux send-keys -t $SESSION_NAME:infra.1 'cd $HOME/.bitcoin/ && clear && bitcoind' C-m
tmux send-keys -t $SESSION_NAME:infra.2 'cd $HOME/ordzaar/ord_dev && clear' C-m
tmux send-keys -t $SESSION_NAME:infra.3 'cd $HOME/.local/share/ord/ && clear && ord server --http-port 4040' C-m
tmux send-keys -t $SESSION_NAME:infra.4 'cd $HOME/ordzaar/ord_dev/ && clear' C-m

# Focus the second pane
tmux select-pane -t $SESSION_NAME:infra.2

# Create the code window with 2 panes split horizontally, upper pane 80%, down pane 20%
if ! tmux list-windows -t $SESSION_NAME | grep -q 'code'; then
    tmux new-window -t $SESSION_NAME:2 -n code
    tmux split-window -v -l 30% -t $SESSION_NAME:code
else
    tmux rename-window -t $SESSION_NAME:2 code
    tmux split-window -v -l 30% -t $SESSION_NAME:code
fi

# # Set the paths for the panes in the code window
tmux send-keys -t $SESSION_NAME:code.1 'cd $HOME/ordzaar/ordit/' C-m
tmux send-keys -t $SESSION_NAME:code.2 'cd $HOME/ordzaar/ordit/ && clear' C-m

# Run 'nvim .' in the first pane of the code window and focus it
tmux send-keys -t $SESSION_NAME:code.1 'nvim .' C-m
tmux select-pane -t $SESSION_NAME:code.3
