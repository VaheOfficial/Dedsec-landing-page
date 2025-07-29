#!/bin/bash

# DEDSEC AI - Node.js Environment Wrapper
# Ensures Node.js is available for the service

# Function to setup Node.js environment
setup_nodejs_env() {
    # Common Node.js installation paths
    NODE_PATHS=(
        "/usr/local/bin"
        "/usr/bin"
        "/opt/node/bin"
        "/home/*/node_modules/.bin"
        "/root/.nvm/versions/node/*/bin"
    )
    
    # Add all possible Node.js paths to PATH
    for path in "${NODE_PATHS[@]}"; do
        if ls $path/node 1> /dev/null 2>&1; then
            export PATH="$path:$PATH"
            break
        fi
    done
    
    # If nvm is available, source it and use latest
    if [ -f "/root/.nvm/nvm.sh" ]; then
        export NVM_DIR="/root/.nvm"
        source "$NVM_DIR/nvm.sh"
        nvm use node 2>/dev/null || nvm use default 2>/dev/null
    elif [ -f "/home/*/.nvm/nvm.sh" ]; then
        for nvm_path in /home/*/.nvm/nvm.sh; do
            if [ -f "$nvm_path" ]; then
                export NVM_DIR="$(dirname "$nvm_path")"
                source "$nvm_path"
                nvm use node 2>/dev/null || nvm use default 2>/dev/null
                break
            fi
        done
    fi
    
    # Ensure common directories are in PATH
    export PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:$PATH"
}

# Setup the environment
setup_nodejs_env

# Get the directory where this wrapper is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Execute the main start script
exec "$SCRIPT_DIR/start-dedsec.sh" 