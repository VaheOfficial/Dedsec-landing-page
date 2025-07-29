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

# Check if required files exist
if [ ! -f "start-dedsec.sh" ]; then
    error "start-dedsec.sh not found in current directory"
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

# Make start script executable
log "Making start script executable..."
chmod +x $INSTALL_DIR/start-dedsec.sh

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

# Install Node.js dependencies
log "Installing Node.js dependencies..."
cd $INSTALL_DIR
sudo -u www-data npm install --production

if [ $? -ne 0 ]; then
    error "Failed to install Node.js dependencies"
    exit 1
fi

# Build the application
log "Building the application..."
sudo -u www-data npm run build

if [ $? -ne 0 ]; then
    error "Failed to build the application"
    exit 1
fi

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