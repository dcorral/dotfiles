#!/bin/bash

# Run the command and capture its exit status
"$@"
STATUS=$?

# Emit a sound and print a message based on the exit status
if [ $STATUS -eq 0 ]; then
    echo "Command finished successfully!"
    for i in {1..10}; do
        echo -e "\a"
        sleep 1
    done
else
    echo "Command failed with status $STATUS!"
    for i in {1..10}; do
        echo -e "\a"
        sleep 1
    done
fi

# Return the original command's exit status
exit $STATUS
