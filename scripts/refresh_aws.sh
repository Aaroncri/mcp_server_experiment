#!/bin/bash

# Check if xclip is installed; if not, install it
if ! command -v xclip &> /dev/null; then
    echo "xclip not found. Installing..."
    sudo apt update && sudo apt install -y xclip
fi

# Prompt the user
echo "Make sure your AWS credentials file is copied to the clipboard."
echo "If not, do so now. Press ENTER when ready to paste it into ~/.aws/credentials."
read -r

# Ensure ~/.aws directory exists
mkdir -p ~/.aws

# Write clipboard contents to ~/.aws/credentials
xclip -selection clipboard -o > ~/.aws/credentials

echo "AWS credentials have been written to ~/.aws/credentials."
