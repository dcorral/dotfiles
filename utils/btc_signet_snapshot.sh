#!/bin/bash

# Define variables
URL="https://forddit.com/bitcoin_signet_snapshot.tar.gz"
SNAPSHOT_FILE="bitcoin_signet_snapshot.tar.gz"
SIGNET_FOLDER="$HOME/.bitcoin/signet"
WALLET_FOLDER="$SIGNET_FOLDER/wallets"
BACKUP_FOLDER="$HOME/wallet_backup"

# Download the snapshot file
echo "Downloading snapshot..."
curl -o $SNAPSHOT_FILE $URL

# Backup the wallet folder
echo "Backing up wallet folder..."
mkdir -p $BACKUP_FOLDER
cp -r $WALLET_FOLDER $BACKUP_FOLDER

# Remove the current signet folder (excluding the wallet folder)
echo "Removing current signet folder..."
rm -rf $SIGNET_FOLDER
mkdir -p $SIGNET_FOLDER

# Extract the downloaded file to the signet folder
echo "Extracting snapshot..."
tar -xzvf $SNAPSHOT_FILE -C $SIGNET_FOLDER

# Restore the wallet folder
echo "Restoring wallet folder..."
cp -r $BACKUP_FOLDER/wallets $SIGNET_FOLDER

# Cleanup
echo "Cleaning up..."
rm -rf $BACKUP_FOLDER
rm $SNAPSHOT_FILE

echo "Done!"
