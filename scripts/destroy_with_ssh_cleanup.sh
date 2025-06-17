#!/bin/bash
set -euo pipefail

# Fetch host info before destroying infra (so outputs are available)
JUMP_IP=$(terraform output -raw jump_box_public_ip 2>/dev/null || true)
MCP_IP=$(terraform output -raw mcp_private_ip 2>/dev/null || true)
AGENT_IP=$(terraform output -raw agent_private_ip 2>/dev/null || true)

# Destroy infra
terraform destroy -auto-approve

# Helper: Remove SSH host key for a given host or IP, if present
remove_ssh_host_key() {
    local host="$1"
    if [ -n "$host" ] && ssh-keygen -F "$host" > /dev/null; then
        echo "Removing SSH key for $host from known_hosts"
        ssh-keygen -R "$host"
    fi
}

# Remove host keys by IP and by SSH config alias
for host in "jump" "mcp" "agent" "$JUMP_IP" "$MCP_IP" "$AGENT_IP"; do
    remove_ssh_host_key "$host"
done

#Remove SSH config include file
SSH_CONFIG_FILE="$HOME/.ssh/config.config.mcp"
if [ -f "$SSH_CONFIG_FILE" ]; then
    rm "$SSH_CONFIG_FILE"
    echo "Removed $SSH_CONFIG_FILE"
fi

echo "Destroyed infra and cleaned up old SSH host keys!"
