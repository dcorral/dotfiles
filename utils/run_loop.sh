#!/bin/bash

# Check if a command was provided
if [ $# -eq 0 ]; then
    echo "No command provided. Usage: $0 <command>"
    exit 1
fi

# Combine all arguments into one command string
COMMAND="$*"

# Run the command in a loop
while true; do
    # Execute the command and capture its output and exit status
    OUTPUT=$($COMMAND 2>&1)
    STATUS=$?

    # Check if the command failed (exit status is not zero)
    if [ $STATUS -ne 0 ]; then
        echo "Command failed with exit status $STATUS:"
        echo "$OUTPUT"
        break # Exit the loop
    fi
done

