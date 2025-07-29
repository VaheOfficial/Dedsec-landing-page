#!/bin/bash

# DEDSEC AI - Service Installation Script
# Sets up the application as a systemd service

# Colors for terminal output
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Variables
SERVICE_NAME="dedsec-ai"
INSTALL_DIR="/opt/dedsec-ai"
SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"
CURRENT_DIR="$(pwd)"

# Functions
log() {
    echo -e "${GREEN}[INSTALL] $1${NC}"
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

# Function to install Node.js system-wide
install_nodejs() {
    log "Checking Node.js installation..."
    
    # Check if Node.js is already installed system-wide
    if command -v node &> /dev/null && command -v npm &> /dev/null; then
        log "Node.js is already installed system-wide"
        log "Node.js version: $(node --version)"
        log "npm version: $(npm --version)"
        return 0
    fi
    
    # Check if user has nvm and Node.js
    if [ -f "$HOME/.nvm/nvm.sh" ] || [ -f "/root/.nvm/nvm.sh" ]; then
        log "Found nvm installation, checking for Node.js..."
        
        # Try to find Node.js from nvm
        if [ -f "$HOME/.nvm/nvm.sh" ]; then
            source "$HOME/.nvm/nvm.sh"
            NODE_VERSION=$(nvm current 2>/dev/null)
        elif [ -f "/root/.nvm/nvm.sh" ]; then
            source "/root/.nvm/nvm.sh"
            NODE_VERSION=$(nvm current 2>/dev/null)
        fi
        
        if [ "$NODE_VERSION" != "system" ] && [ ! -z "$NODE_VERSION" ]; then
            log "Found Node.js $NODE_VERSION via nvm"
            
            # Create symlinks for system-wide access
            NODE_PATH=$(which node)
            NPM_PATH=$(which npm)
            
            if [ ! -z "$NODE_PATH" ] && [ ! -z "$NPM_PATH" ]; then
                log "Creating system-wide symlinks..."
                ln -sf "$NODE_PATH" /usr/local/bin/node
                ln -sf "$NPM_PATH" /usr/local/bin/npm
                log "Node.js is now available system-wide"
                return 0
            fi
        fi
    fi
    
    # Install Node.js system-wide if not found
    log "Installing Node.js system-wide..."
    
    # Detect package manager
    if command -v apt-get &> /dev/null; then
        log "Using apt-get to install Node.js..."
        curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
        apt-get install -y nodejs
    elif command -v yum &> /dev/null; then
        log "Using yum to install Node.js..."
        curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash -
        yum install -y nodejs npm
    elif command -v dnf &> /dev/null; then
        log "Using dnf to install Node.js..."
        curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash -
        dnf install -y nodejs npm
    else
        error "Could not detect package manager. Please install Node.js manually."
        error "Visit: https://nodejs.org/en/download/"
        exit 1
    fi
    
    # Verify installation
    if command -v node &> /dev/null && command -v npm &> /dev/null; then
        log "Node.js installed successfully!"
        log "Node.js version: $(node --version)"
        log "npm version: $(npm --version)"
    else
        error "Failed to install Node.js"
        exit 1
    fi
}

# ASCII Art Banner
echo -e "${GREEN}"
echo "██████╗ ███████╗██████╗ ███████╗███████╗ ██████╗    █████╗ ██╗"
echo "██╔══██╗██╔════╝██╔══██╗██╔════╝██╔════╝██╔════╝   ██╔══██╗██║"
echo "██║  ██║█████╗  ██║  ██║███████╗█████╗  ██║        ███████║██║"
echo "██║  ██║██╔══╝  ██║  ██║╚════██║██╔══╝  ██║        ██╔══██║██║"
echo "██████╔╝███████╗██████╔╝███████║███████╗╚██████╗   ██║  ██║██║"
echo "╚═════╝ ╚══════╝╚═════╝ ╚══════╝╚══════╝ ╚═════╝   ╚═╝  ╚═╝╚═╝"
echo -e "${NC}"
echo -e "${CYAN}Service Installation - Neural Network Infiltration System${NC}"
echo ""

log "Starting Dedsec AI service installation..."

# Install or setup Node.js
install_nodejs

# Check if required files exist
if [ ! -f "start-dedsec.sh" ]; then
    error "start-dedsec.sh not found in current directory"
    exit 1
fi

if [ ! -f "dedsec-wrapper.sh" ]; then
    error "dedsec-wrapper.sh not found in current directory"
    exit 1
fi

if [ ! -f "dedsec-ai.service" ]; then
    error "dedsec-ai.service not found in current directory"
    exit 1
fi

if [ ! -f "package.json" ]; then
    error "package.json not found in current directory"
    exit 1
fi

# Stop existing service if running
if systemctl is-active --quiet $SERVICE_NAME; then
    log "Stopping existing $SERVICE_NAME service..."
    systemctl stop $SERVICE_NAME
fi

# Create installation directory
log "Creating installation directory: $INSTALL_DIR"
mkdir -p $INSTALL_DIR

# Copy application files
log "Copying application files..."
cp -r * $INSTALL_DIR/
chown -R www-data:www-data $INSTALL_DIR

# Make scripts executable
log "Making scripts executable..."
chmod +x $INSTALL_DIR/start-dedsec.sh
chmod +x $INSTALL_DIR/dedsec-wrapper.sh

# Install systemd service
log "Installing systemd service..."
cp dedsec-ai.service $SERVICE_FILE

# Reload systemd
log "Reloading systemd daemon..."
systemctl daemon-reload

# Enable service
log "Enabling $SERVICE_NAME service..."
systemctl enable $SERVICE_NAME

# Create user if it doesn't exist
if ! id "www-data" &>/dev/null; then
    log "Creating www-data user..."
    useradd -r -s /bin/false www-data
fi

# Set proper permissions
log "Setting file permissions..."
chown -R www-data:www-data $INSTALL_DIR
chmod -R 755 $INSTALL_DIR
chmod +x $INSTALL_DIR/start-dedsec.sh
chmod +x $INSTALL_DIR/dedsec-wrapper.sh

# Install Node.js dependencies
log "Installing Node.js dependencies..."
cd $INSTALL_DIR

# Run npm as root and then fix ownership
npm install --production

if [ $? -ne 0 ]; then
    error "Failed to install Node.js dependencies"
    exit 1
fi

# Build the application
log "Building the application..."
npm run build

if [ $? -ne 0 ]; then
    error "Failed to build the application"
    exit 1
fi

# Fix ownership after npm operations
log "Setting correct ownership for npm-generated files..."
chown -R www-data:www-data $INSTALL_DIR

# Start the service
log "Starting $SERVICE_NAME service..."
systemctl start $SERVICE_NAME

# Check service status
sleep 3
if systemctl is-active --quiet $SERVICE_NAME; then
    log "Service started successfully!"
    
    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}                    INSTALLATION COMPLETE                      ${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    info "Dedsec AI is now running as a system service"
    info "Access URL: http://localhost:7443"
    echo ""
    echo -e "${YELLOW}Service Management Commands:${NC}"
    echo "  Start:   sudo systemctl start $SERVICE_NAME"
    echo "  Stop:    sudo systemctl stop $SERVICE_NAME"
    echo "  Restart: sudo systemctl restart $SERVICE_NAME"
    echo "  Status:  sudo systemctl status $SERVICE_NAME"
    echo "  Logs:    sudo journalctl -u $SERVICE_NAME -f"
    echo ""
    echo -e "${YELLOW}Service Status:${NC}"
    systemctl status $SERVICE_NAME --no-pager -l
    echo ""
    echo -e "${GREEN}[SYSTEM_STATUS] ONLINE${NC}"
    echo -e "${GREEN}[NEURAL_CORE] OPERATIONAL${NC}"
    echo -e "${GREEN}[ACCESS_GRANTED] Welcome, RedactMe${NC}"
    
else
    error "Failed to start service. Check logs with: sudo journalctl -u $SERVICE_NAME"
    echo ""
    echo -e "${YELLOW}Service logs:${NC}"
    journalctl -u $SERVICE_NAME --no-pager -l
    exit 1
fi 