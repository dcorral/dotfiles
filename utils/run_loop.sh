#!/bin/bash

# Function to print the summary
print_summary() {
    if [ "$SUMMARY_PRINTED" == "true" ]; then
        return
    fi
    SUMMARY_PRINTED="true"

    # Calculate duration
    DURATION=$SECONDS

    # Calculate hours, minutes, seconds from SECONDS
    let "hours=SECONDS/3600"
    let "minutes=(SECONDS%3600)/60"
    let "seconds=(SECONDS%3600)%60"

    # Print summary
    echo -e "\n-----------------------------------"
    echo "Summary:"
    echo "Total Duration: $hours hour(s) $minutes minute(s) $seconds second(s) ($DURATION seconds)"
    echo "Total Runs: $COUNTER"
    echo "-----------------------------------"
}

# Check if a command was provided
if [ $# -eq 0 ]; then
    echo "No command provided. Usage: $0 <command>"
    exit 1
fi

# Combine all arguments into one command string
COMMAND="$*"

# Initialize the counter and summary printed flag
COUNTER=0
SUMMARY_PRINTED="false"

# Reset SECONDS to start timing the loop
SECONDS=0

# Setup trap to catch SIGINT (Ctrl+C) and call print_summary function
trap print_summary SIGINT

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

        # Call the function to print summary upon failure
        print_summary

        break # Exit the loop
    fi
done

