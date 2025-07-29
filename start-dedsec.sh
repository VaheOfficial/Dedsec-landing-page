#!/bin/bash

# DEDSEC AI - Startup Script
# Automatically builds and runs the application on port 7443

# Colors for terminal output
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ASCII Art Banner
echo -e "${GREEN}"
echo "██████╗ ███████╗██████╗ ███████╗███████╗ ██████╗    █████╗ ██╗"
echo "██╔══██╗██╔════╝██╔══██╗██╔════╝██╔════╝██╔════╝   ██╔══██╗██║"
echo "██║  ██║█████╗  ██║  ██║███████╗█████╗  ██║        ███████║██║"
echo "██║  ██║██╔══╝  ██║  ██║╚════██║██╔══╝  ██║        ██╔══██║██║"
echo "██████╔╝███████╗██████╔╝███████║███████╗╚██████╗   ██║  ██║██║"
echo "╚═════╝ ╚══════╝╚═════╝ ╚══════╝╚══════╝ ╚═════╝   ╚═╝  ╚═╝╚═╝"
echo -e "${NC}"
echo -e "${CYAN}[SYSTEM] Neural Network Infiltration System v2.1.0${NC}"
echo -e "${CYAN}[OPERATOR] RedactMe${NC}"
echo -e "${YELLOW}[PORT] 7443${NC}"
echo ""

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Function to log messages
log() {
    echo -e "${GREEN}[$(date '+%Y-%m-%d %H:%M:%S')] $1${NC}"
}

error() {
    echo -e "${RED}[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}"
}

warning() {
    echo -e "${YELLOW}[$(date '+%Y-%m-%d %H:%M:%S')] WARNING: $1${NC}"
}

# Function to setup Node.js environment
setup_nodejs() {
    # Try to find Node.js in common locations
    NODE_PATHS=(
        "/usr/bin/node"
        "/usr/local/bin/node"
        "$HOME/.nvm/versions/node/*/bin/node"
        "/root/.nvm/versions/node/*/bin/node"
    )
    
    NPM_PATHS=(
        "/usr/bin/npm"
        "/usr/local/bin/npm"
        "$HOME/.nvm/versions/node/*/bin/npm"
        "/root/.nvm/versions/node/*/bin/npm"
    )
    
    # Check if nvm is available and source it
    if [ -f "$HOME/.nvm/nvm.sh" ]; then
        log "Loading nvm from user home..."
        export NVM_DIR="$HOME/.nvm"
        source "$NVM_DIR/nvm.sh"
        nvm use node 2>/dev/null || nvm use default 2>/dev/null
    elif [ -f "/root/.nvm/nvm.sh" ]; then
        log "Loading nvm from root..."
        export NVM_DIR="/root/.nvm"
        source "$NVM_DIR/nvm.sh"
        nvm use node 2>/dev/null || nvm use default 2>/dev/null
    fi
    
    # Find Node.js executable
    NODE_CMD=""
    for path in "${NODE_PATHS[@]}"; do
        if [ -x "$path" ] || ls $path 1> /dev/null 2>&1; then
            NODE_CMD=$(ls $path 2>/dev/null | head -1)
            if [ -x "$NODE_CMD" ]; then
                break
            fi
        fi
    done
    
    # Find npm executable
    NPM_CMD=""
    for path in "${NPM_PATHS[@]}"; do
        if [ -x "$path" ] || ls $path 1> /dev/null 2>&1; then
            NPM_CMD=$(ls $path 2>/dev/null | head -1)
            if [ -x "$NPM_CMD" ]; then
                break
            fi
        fi
    done
    
    # Set up PATH to include Node.js
    if [ ! -z "$NODE_CMD" ]; then
        NODE_DIR=$(dirname "$NODE_CMD")
        export PATH="$NODE_DIR:$PATH"
        log "Found Node.js at: $NODE_CMD"
    fi
    
    if [ ! -z "$NPM_CMD" ]; then
        NPM_DIR=$(dirname "$NPM_CMD")
        export PATH="$NPM_DIR:$PATH"
        log "Found npm at: $NPM_CMD"
    fi
}

# Setup Node.js environment
setup_nodejs

# Check if Node.js is now available
if ! command -v node &> /dev/null; then
    error "Node.js is not found. Please install Node.js or nvm first."
    error "For system-wide install: curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - && sudo apt-get install -y nodejs"
    exit 1
fi

# Check if npm is available
if ! command -v npm &> /dev/null; then
    error "npm is not found. Please install npm."
    exit 1
fi

log "Node.js version: $(node --version)"
log "npm version: $(npm --version)"

# Check if package.json exists
if [ ! -f "package.json" ]; then
    error "package.json not found. Make sure you're in the correct directory."
    exit 1
fi

# Function to cleanup on exit
cleanup() {
    log "Shutting down Dedsec AI..."
    if [ ! -z "$NEXT_PID" ]; then
        kill $NEXT_PID 2>/dev/null
    fi
    exit 0
}

# Set up signal handlers
trap cleanup SIGINT SIGTERM

# Install dependencies if node_modules doesn't exist or package-lock.json is newer
if [ ! -d "node_modules" ] || [ "package-lock.json" -nt "node_modules" ]; then
    log "Installing dependencies..."
    npm install
    if [ $? -ne 0 ]; then
        error "Failed to install dependencies"
        exit 1
    fi
else
    log "Dependencies already installed"
fi

# Build the application
log "Building Dedsec AI application..."
npm run build
if [ $? -ne 0 ]; then
    error "Build failed"
    exit 1
fi

log "Build completed successfully"

# Check if port 7443 is already in use
if lsof -Pi :7443 -sTCP:LISTEN -t >/dev/null ; then
    warning "Port 7443 is already in use. Attempting to kill existing processes..."
    lsof -ti:7443 | xargs kill -9 2>/dev/null
    sleep 2
fi

# Set the port
export PORT=7443

log "Starting Dedsec AI on port 7443..."
log "Access the application at: https://localhost:7443 or http://localhost:7443"
echo ""
echo -e "${CYAN}[SYSTEM_STATUS] ONLINE${NC}"
echo -e "${CYAN}[NEURAL_CORE] OPERATIONAL${NC}"
echo -e "${CYAN}[SECURITY_LEVEL] MAXIMUM${NC}"
echo -e "${GREEN}[ACCESS_GRANTED] Welcome, RedactMe${NC}"
echo ""
echo -e "${YELLOW}Press Ctrl+C to stop the server${NC}"
echo ""

# Start the application
npm start &
NEXT_PID=$!

# Wait for the process to start
sleep 3

# Check if the process is still running
if kill -0 $NEXT_PID 2>/dev/null; then
    log "Dedsec AI is running on port 7443 (PID: $NEXT_PID)"
    
    # Keep the script running and monitor the process
    while kill -0 $NEXT_PID 2>/dev/null; do
        sleep 5
    done
    
    error "Application process died unexpectedly"
    exit 1
else
    error "Failed to start the application"
    exit 1
fi 