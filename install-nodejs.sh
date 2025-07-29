#!/bin/bash

# DEDSEC AI - Node.js Installation Script
# Installs Node.js system-wide for service compatibility

# Colors for terminal output
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions
log() {
    echo -e "${GREEN}[NODEJS] $1${NC}"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}"
}

warning() {
    echo -e "${YELLOW}[WARNING] $1${NC}"
}

info() {
    echo -e "${CYAN}[INFO] $1${NC}"
}

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   error "This script must be run as root (use sudo)"
   exit 1
fi

# Banner
echo -e "${GREEN}"
echo "███╗   ██╗ ██████╗ ██████╗ ███████╗      ██╗███████╗"
echo "████╗  ██║██╔═══██╗██╔══██╗██╔════╝      ██║██╔════╝"
echo "██╔██╗ ██║██║   ██║██║  ██║█████╗        ██║███████╗"
echo "██║╚██╗██║██║   ██║██║  ██║██╔══╝   ██   ██║╚════██║"
echo "██║ ╚████║╚██████╔╝██████╔╝███████╗ ╚█████╔╝███████║"
echo "╚═╝  ╚═══╝ ╚═════╝ ╚═════╝ ╚══════╝  ╚════╝ ╚══════╝"
echo -e "${NC}"
echo -e "${CYAN}Node.js System Installation for Dedsec AI${NC}"
echo ""

log "Starting Node.js installation..."

# Check if Node.js is already installed
if command -v node &> /dev/null && command -v npm &> /dev/null; then
    log "Node.js is already installed!"
    log "Node.js version: $(node --version)"
    log "npm version: $(npm --version)"
    
    # Check if it's accessible system-wide
    if [ -x "/usr/local/bin/node" ] || [ -x "/usr/bin/node" ]; then
        log "Node.js is available system-wide ✓"
        exit 0
    else
        warning "Node.js found but not in system PATH, creating symlinks..."
        NODE_PATH=$(which node)
        NPM_PATH=$(which npm)
        
        if [ ! -z "$NODE_PATH" ] && [ ! -z "$NPM_PATH" ]; then
            ln -sf "$NODE_PATH" /usr/local/bin/node
            ln -sf "$NPM_PATH" /usr/local/bin/npm
            log "System-wide symlinks created ✓"
            exit 0
        fi
    fi
fi

# Try to source nvm and create symlinks if Node.js is found
if [ -f "/root/.nvm/nvm.sh" ]; then
    log "Found nvm installation, sourcing..."
    source "/root/.nvm/nvm.sh"
    
    if nvm current &> /dev/null; then
        NODE_VERSION=$(nvm current)
        log "Found Node.js $NODE_VERSION via nvm"
        
        NODE_PATH=$(which node)
        NPM_PATH=$(which npm)
        
        if [ ! -z "$NODE_PATH" ] && [ ! -z "$NPM_PATH" ]; then
            log "Creating system-wide symlinks..."
            ln -sf "$NODE_PATH" /usr/local/bin/node
            ln -sf "$NPM_PATH" /usr/local/bin/npm
            log "Node.js is now available system-wide ✓"
            exit 0
        fi
    fi
fi

# Check for user nvm installations
for user_home in /home/*/; do
    if [ -f "${user_home}.nvm/nvm.sh" ]; then
        log "Found nvm in $user_home, checking Node.js..."
        source "${user_home}.nvm/nvm.sh"
        
        if nvm current &> /dev/null; then
            NODE_VERSION=$(nvm current)
            log "Found Node.js $NODE_VERSION via user nvm"
            
            NODE_PATH=$(which node)
            NPM_PATH=$(which npm)
            
            if [ ! -z "$NODE_PATH" ] && [ ! -z "$NPM_PATH" ]; then
                log "Creating system-wide symlinks..."
                ln -sf "$NODE_PATH" /usr/local/bin/node
                ln -sf "$NPM_PATH" /usr/local/bin/npm
                log "Node.js is now available system-wide ✓"
                exit 0
            fi
        fi
    fi
done

# Install Node.js system-wide
log "Installing Node.js system-wide..."

# Detect package manager and install
if command -v apt-get &> /dev/null; then
    log "Detected apt-get package manager"
    log "Adding NodeSource repository..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
    log "Installing Node.js..."
    apt-get install -y nodejs
    
elif command -v yum &> /dev/null; then
    log "Detected yum package manager"
    log "Adding NodeSource repository..."
    curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash -
    log "Installing Node.js..."
    yum install -y nodejs npm
    
elif command -v dnf &> /dev/null; then
    log "Detected dnf package manager"
    log "Adding NodeSource repository..."
    curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash -
    log "Installing Node.js..."
    dnf install -y nodejs npm
    
elif command -v pacman &> /dev/null; then
    log "Detected pacman package manager"
    log "Installing Node.js..."
    pacman -S --noconfirm nodejs npm
    
else
    error "Could not detect a supported package manager"
    error "Supported: apt-get, yum, dnf, pacman"
    error "Please install Node.js manually from: https://nodejs.org/"
    exit 1
fi

# Verify installation
if command -v node &> /dev/null && command -v npm &> /dev/null; then
    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}                    INSTALLATION SUCCESS                       ${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    log "Node.js installed successfully!"
    log "Node.js version: $(node --version)"
    log "npm version: $(npm --version)"
    log "Location: $(which node)"
    echo ""
    info "Node.js is now ready for Dedsec AI service!"
    info "You can now run: sudo ./install-service.sh"
    echo ""
else
    error "Installation failed - Node.js not found in PATH"
    error "Please check the installation logs above"
    exit 1
fi 