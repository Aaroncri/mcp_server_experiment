#!/bin/bash
set -e

LOCAL_PORT=7860
REMOTE_PORT=7860
REMOTE_HOST=mcp    # Uses your SSH config alias

echo "Creating SSH tunnel: localhost:$LOCAL_PORT → $REMOTE_HOST:$REMOTE_PORT (via jump box)"
echo "Press Ctrl+C to close the tunnel."

ssh -N -L ${LOCAL_PORT}:localhost:${REMOTE_PORT} ${REMOTE_HOST}
