#!/bin/bash

# Check if a command was provided
if [ $# -eq 0 ]; then
    echo "No command provided. Usage: $0 <command>"
    exit 1
fi

# Combine all arguments into one command string
COMMAND="$*"

# Initialize the counter
COUNTER=0

# Reset SECONDS to start timing the loop
SECONDS=0

# Run the command in a loop
while true; do
    # Increment the counter
    ((COUNTER++))

    # Execute the command and capture its output and exit status
    OUTPUT=$($COMMAND 2>&1)
    STATUS=$?

    # Check if the command failed (exit status is not zero)
    if [ $STATUS -ne 0 ]; then
        echo "Command failed with exit status $STATUS:"
        echo "$OUTPUT"

        # Calculate duration
        DURATION=$SECONDS

        # Calculate hours, minutes, seconds from SECONDS
        let "hours=SECONDS/3600"
        let "minutes=(SECONDS%3600)/60"
        let "seconds=(SECONDS%3600)%60"

        # Print summary
        echo "-----------------------------------"
        echo "Summary:"
        echo "Total Duration: $hours hour(s) $minutes minute(s) $seconds second(s) ($DURATION seconds)"
        echo "Total Runs: $COUNTER"
        echo "-----------------------------------"

        break # Exit the loop
    fi
done

