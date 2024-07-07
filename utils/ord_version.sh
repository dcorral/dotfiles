#!/bin/bash

# Check if the first parameter is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <origin|upstream>"
    exit 1
fi

# Set variables
REPO_DIR="/home/dcorral/ordzaar/ord"
BIN_DIR="/home/dcorral/ordzaar/ord_dev/bin"
TARGET_BINARY="target/release/ord"
UPSTREAM_BRANCH="upstream-0.18.5"
TAG_NAME="0.18.5"

# Navigate to the repository directory
cd "$REPO_DIR" || { echo "Repository directory not found"; exit 1; }

# Fetch the latest changes
git fetch --all --tags

# Switch to the appropriate branch or tag
if [ "$1" == "origin" ]; then
    git checkout origin/master || { echo "Failed to checkout origin/master"; exit 1; }
elif [ "$1" == "upstream" ]; then
    if git rev-parse --verify "$UPSTREAM_BRANCH" >/dev/null 2>&1; then
        git checkout "$UPSTREAM_BRANCH" || { echo "Failed to checkout branch $UPSTREAM_BRANCH"; exit 1; }
    else
        git checkout -b "$UPSTREAM_BRANCH" "tags/$TAG_NAME" || { echo "Failed to checkout tag $TAG_NAME"; exit 1; }
    fi
else
    echo "Invalid parameter: $1"
    echo "Usage: $0 <origin|upstream>"
    exit 1
fi

cargo build --release || { echo "Cargo build failed"; exit 1; }

# Move the binary to the target directory
cp "$TARGET_BINARY" "$BIN_DIR" || { echo "Failed to move binary to $BIN_DIR"; exit 1; }

echo "Build and deployment successful!"

