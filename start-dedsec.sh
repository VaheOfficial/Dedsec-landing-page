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

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    error "Node.js is not installed. Please install Node.js first."
    exit 1
fi

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    error "npm is not installed. Please install npm first."
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