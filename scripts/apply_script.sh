#!/bin/bash
set -euo pipefail

KEY_NAME="mcp_project_key"
KEY_PATH="$HOME/.ssh/$KEY_NAME"
PUB_KEY_PATH="${KEY_PATH}.pub"
SSH_CONFIG_FILE="$HOME/.ssh/config.mcp"
MAIN_SSH_CONFIG="$HOME/.ssh/config"

# 1. Generate SSH key if it doesn't exist
if [ ! -f "$KEY_PATH" ]; then
    echo "Generating SSH key $KEY_PATH..."
    ssh-keygen -t ed25519 -N "" -f "$KEY_PATH"
else
    echo "SSH key $KEY_PATH already exists."
fi

# 2. Run Terraform apply, providing key info as vars
terraform apply -auto-approve \
    -var="public_key_path=$PUB_KEY_PATH" \
    -var="key_name=$KEY_NAME"

# 3. Fetch IPs and user from Terraform output
JUMP_IP=$(terraform output -raw jump_box_public_ip)
AGENT_IP=$(terraform output -raw agent_private_ip)
MCP_IP=$(terraform output -raw mcp_private_ip)
USER=$(terraform output -raw jump_box_user 2>/dev/null || echo "ubuntu")

# 4. Write SSH config entries to a dedicated config include
cat > "$SSH_CONFIG_FILE" <<EOF
Host jump
    HostName $JUMP_IP
    User $USER
    IdentityFile $KEY_PATH
    ForwardAgent yes

Host agent
    HostName $AGENT_IP
    User $USER
    IdentityFile $KEY_PATH
    ProxyJump jump

Host mcp
    HostName $MCP_IP
    User $USER
    IdentityFile $KEY_PATH
    ProxyJump jump
EOF

echo "Wrote SSH config to $SSH_CONFIG_FILE"

# 5. Ensure main SSH config includes this file
if [ -f "$MAIN_SSH_CONFIG" ]; then
    if ! grep -q "Include $SSH_CONFIG_FILE" "$MAIN_SSH_CONFIG"; then
        echo -e "\nInclude $SSH_CONFIG_FILE" >> "$MAIN_SSH_CONFIG"
        echo "Added 'Include $SSH_CONFIG_FILE' to your ~/.ssh/config"
    fi
else
    echo "Include $SSH_CONFIG_FILE" > "$MAIN_SSH_CONFIG"
    echo "Created new ~/.ssh/config with include."
fi

echo "Done! You can now ssh jump, ssh agent, or ssh mcp."
