#!/bin/bash

# DEDSEC AI - Permission Fix Script
# Fixes ownership and permission issues for the service

# Colors for terminal output
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Variables
INSTALL_DIR="/opt/dedsec-ai"

# Functions
log() {
    echo -e "${GREEN}[FIX] $1${NC}"
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
echo "███████╗██╗██╗  ██╗    ██████╗ ███████╗██████╗ ███╗   ███╗███████╗"
echo "██╔════╝██║╚██╗██╔╝    ██╔══██╗██╔════╝██╔══██╗████╗ ████║██╔════╝"
echo "█████╗  ██║ ╚███╔╝     ██████╔╝█████╗  ██████╔╝██╔████╔██║███████╗"
echo "██╔══╝  ██║ ██╔██╗     ██╔═══╝ ██╔══╝  ██╔══██╗██║╚██╔╝██║╚════██║"
echo "██║     ██║██╔╝ ██╗    ██║     ███████╗██║  ██║██║ ╚═╝ ██║███████║"
echo "╚═╝     ╚═╝╚═╝  ╚═╝    ╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝"
echo -e "${NC}"
echo -e "${CYAN}Permission Fix for Dedsec AI${NC}"
echo ""

log "Starting permission fix..."

# Check if install directory exists
if [ ! -d "$INSTALL_DIR" ]; then
    error "Installation directory $INSTALL_DIR not found"
    error "Please run the installation script first"
    exit 1
fi

# Create www-data user if it doesn't exist
if ! id "www-data" &>/dev/null; then
    log "Creating www-data user..."
    useradd -r -s /bin/false www-data
fi

# Fix ownership of entire directory
log "Fixing ownership of $INSTALL_DIR..."
chown -R www-data:www-data $INSTALL_DIR

# Set correct permissions
log "Setting correct permissions..."
chmod -R 755 $INSTALL_DIR

# Make scripts executable
log "Making scripts executable..."
chmod +x $INSTALL_DIR/*.sh

# Fix specific npm/build directories if they exist
if [ -d "$INSTALL_DIR/node_modules" ]; then
    log "Fixing node_modules permissions..."
    chown -R www-data:www-data $INSTALL_DIR/node_modules
    chmod -R 755 $INSTALL_DIR/node_modules
fi

if [ -d "$INSTALL_DIR/.next" ]; then
    log "Fixing .next build directory permissions..."
    chown -R www-data:www-data $INSTALL_DIR/.next
    chmod -R 755 $INSTALL_DIR/.next
fi

# Fix package files
for file in package.json package-lock.json; do
    if [ -f "$INSTALL_DIR/$file" ]; then
        log "Fixing $file permissions..."
        chown www-data:www-data "$INSTALL_DIR/$file"
        chmod 644 "$INSTALL_DIR/$file"
    fi
done

# Test if www-data can access the files
log "Testing www-data access..."
if sudo -u www-data test -r "$INSTALL_DIR/package.json"; then
    log "✓ www-data can read package.json"
else
    error "✗ www-data cannot read package.json"
fi

if sudo -u www-data test -x "$INSTALL_DIR/start-dedsec.sh"; then
    log "✓ www-data can execute start-dedsec.sh"
else
    error "✗ www-data cannot execute start-dedsec.sh"
fi

if [ -d "$INSTALL_DIR/node_modules" ]; then
    if sudo -u www-data test -r "$INSTALL_DIR/node_modules"; then
        log "✓ www-data can access node_modules"
    else
        error "✗ www-data cannot access node_modules"
    fi
fi

echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}                    PERMISSION FIX COMPLETE                    ${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo ""

info "All permissions have been fixed for Dedsec AI"
info "You can now restart the service:"
echo ""
echo "  sudo systemctl restart dedsec-ai"
echo "  sudo systemctl status dedsec-ai"
echo ""

log "Permission fix completed successfully!" 