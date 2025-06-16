#!/bin/bash
set -xe

# Log output to both file and console for easier debugging
exec > >(tee /var/log/langflow-setup.log|logger -t user-data -s 2>/dev/console) 2>&1

# Update and install system dependencies
for i in {1..10}; do
  apt update && break
  echo "Retrying apt update in 10s..."
  sleep 10
done

apt install -y python3 python3-pip python3-venv build-essential python3-dev

# Set up Langflow install directory
INSTALL_DIR="/opt/langflow"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

# Create and activate Python virtual environment
python3 -m venv .venv
source .venv/bin/activate

# Upgrade pip, install uv, and then Langflow (inside venv)
python -m pip install --upgrade pip
python -m pip install uv
uv pip install langflow

#Install npm
sudo apt install -y npm 

#Install MCP inspector: 
npx @modelcontextprotocol/inspector

# Start Langflow in the background, listening on all interfaces
nohup "$INSTALL_DIR/.venv/bin/langflow" run --host 0.0.0.0 > /var/log/langflow.log 2>&1 &
