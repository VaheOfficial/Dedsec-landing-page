# 🔥 DEDSEC AI - Service Setup Guide

```
██████╗ ███████╗██████╗ ███████╗███████╗ ██████╗    █████╗ ██╗
██╔══██╗██╔════╝██╔══██╗██╔════╝██╔════╝██╔════╝   ██╔══██╗██║
██║  ██║█████╗  ██║  ██║███████╗█████╗  ██║        ███████║██║
██║  ██║██╔══╝  ██║  ██║╚════██║██╔══╝  ██║        ██╔══██║██║
██████╔╝███████╗██████╔╝███████║███████╗╚██████╗   ██║  ██║██║
╚═════╝ ╚══════╝╚═════╝ ╚══════╝╚══════╝ ╚═════╝   ╚═╝  ╚═╝╚═╝
```

**Neural Network Infiltration System - Service Configuration**  
**Operator:** RedactMe  
**Port:** 7443  

## 📋 Overview

This guide will help you set up Dedsec AI as an automatic system service that:
- ✅ Automatically builds and runs on port 7443
- ✅ Starts on system boot
- ✅ Auto-restarts on crashes
- ✅ Runs with proper security isolation
- ✅ Provides comprehensive logging

## ⚡ Quick Fix for Common Issues

**Getting "user root is not allowed to execute npm as www-data" error?**
```bash
chmod +x *.sh
sudo ./fix-permissions.sh
sudo systemctl restart dedsec-ai
```

**Getting "npm not found" or "node not found" error?**
```bash
sudo ./install-nodejs.sh
sudo ./install-service.sh
```

## 🚀 Quick Setup

### Option 1: Automatic Service Installation (Recommended)

1. **Make scripts executable:**
   ```bash
   chmod +x *.sh
   ```

2. **If you have Node.js via nvm only, install system-wide:**
   ```bash
   sudo ./install-nodejs.sh
   ```

3. **Run the automatic installer:**
   ```bash
   sudo ./install-service.sh
   ```

4. **Access your application:**
   ```
   🌐 http://localhost:7443
   ```

### Option 2: Manual Setup

1. **Make the startup script executable:**
   ```bash
   chmod +x start-dedsec.sh
   ```

2. **Run directly (for testing):**
   ```bash
   ./start-dedsec.sh
   ```

## 📁 Files Created

| File | Purpose |
|------|---------|
| `start-dedsec.sh` | Main startup script with ASCII art and monitoring |
| `dedsec-wrapper.sh` | Node.js environment wrapper for service compatibility |
| `dedsec-ai.service` | Systemd service configuration |
| `install-service.sh` | Automatic service installation script |
| `install-nodejs.sh` | Standalone Node.js system installation script |
| `fix-permissions.sh` | Permission fix script for sudo issues |

## 🛠️ Service Management

After installation, use these commands to manage your service:

```bash
# Start the service
sudo systemctl start dedsec-ai

# Stop the service
sudo systemctl stop dedsec-ai

# Restart the service
sudo systemctl restart dedsec-ai

# Check service status
sudo systemctl status dedsec-ai

# View real-time logs
sudo journalctl -u dedsec-ai -f

# Enable auto-start on boot (done automatically)
sudo systemctl enable dedsec-ai

# Disable auto-start on boot
sudo systemctl disable dedsec-ai
```

## 🔧 Configuration Details

### Startup Script Features
- **Dependency Checking:** Validates Node.js and npm installation
- **Port Management:** Automatically kills processes on port 7443
- **Build Process:** Runs `npm install` and `npm run build`
- **Process Monitoring:** Keeps track of the application process
- **Graceful Shutdown:** Handles SIGINT and SIGTERM signals
- **Visual Feedback:** Cyberpunk-themed ASCII art and colored output

### Service Configuration
- **User:** Runs as `www-data` for security
- **Working Directory:** `/opt/dedsec-ai`
- **Environment:** Production mode on port 7443
- **Auto-Restart:** Restarts on failure with 10-second delay
- **Security:** Hardened with various protection flags
- **Logging:** Outputs to systemd journal

### Security Features
- ✅ Runs as unprivileged user (`www-data`)
- ✅ Protected system directories
- ✅ Private temporary files
- ✅ Restricted device access
- ✅ Kernel protection enabled
- ✅ No new privileges allowed

## 🐛 Troubleshooting

### Node.js Issues (Most Common)

If you get "npm not found" or "node not found" errors:

1. **Install Node.js system-wide:**
   ```bash
   sudo ./install-nodejs.sh
   ```

2. **Or manually create symlinks if you have nvm:**
   ```bash
   # Find your Node.js installation
   which node
   which npm
   
   # Create system-wide symlinks (replace paths with your actual paths)
   sudo ln -sf /path/to/your/node /usr/local/bin/node
   sudo ln -sf /path/to/your/npm /usr/local/bin/npm
   ```

3. **Verify Node.js is available system-wide:**
   ```bash
   sudo -u www-data which node
   sudo -u www-data which npm
   ```

### Service Won't Start
```bash
# Check service status
sudo systemctl status dedsec-ai

# View detailed logs
sudo journalctl -u dedsec-ai -n 50

# Check if port is in use
sudo lsof -i :7443
```

### Build Failures
```bash
# Check Node.js version (requires Node.js 18+)
node --version

# Manual build test
cd /opt/dedsec-ai
sudo -u www-data npm install
sudo -u www-data npm run build
```

### Permission Issues

**If you get "user root is not allowed to execute npm as www-data" error:**

1. **Use the automatic fix script:**
   ```bash
   chmod +x fix-permissions.sh
   sudo ./fix-permissions.sh
   ```

2. **Or manually fix permissions:**
   ```bash
   # Fix ownership
   sudo chown -R www-data:www-data /opt/dedsec-ai

   # Fix permissions
   sudo chmod -R 755 /opt/dedsec-ai
   sudo chmod +x /opt/dedsec-ai/*.sh
   
   # Restart the service
   sudo systemctl restart dedsec-ai
   ```

3. **For severe sudo restrictions, modify /etc/sudoers:**
   ```bash
   sudo visudo
   # Add this line:
   # root ALL=(www-data) NOPASSWD: /usr/bin/npm, /usr/local/bin/npm
   ```

## 🔄 Updates

To update the application:

1. **Stop the service:**
   ```bash
   sudo systemctl stop dedsec-ai
   ```

2. **Update files in `/opt/dedsec-ai`**

3. **Restart the service:**
   ```bash
   sudo systemctl start dedsec-ai
   ```

## 🗑️ Uninstallation

To completely remove the service:

```bash
# Stop and disable service
sudo systemctl stop dedsec-ai
sudo systemctl disable dedsec-ai

# Remove service file
sudo rm /etc/systemd/system/dedsec-ai.service

# Reload systemd
sudo systemctl daemon-reload

# Remove application directory
sudo rm -rf /opt/dedsec-ai
```

## 📊 System Requirements

- **OS:** Linux with systemd
- **Node.js:** v18.0.0 or higher
- **RAM:** 512MB minimum (1GB recommended)
- **Disk:** 500MB for application + dependencies
- **Network:** Port 7443 available

## 🎯 Access Information

Once running, access your Dedsec AI interface at:

- **Local:** http://localhost:7443
- **Network:** http://[your-server-ip]:7443

## 🔐 Security Notes

- The service runs as `www-data` user for security
- Multiple systemd security features are enabled
- The application is isolated from system resources
- Logs are available through systemd journal
- Automatic restarts prevent prolonged downtime

---

**[SYSTEM_STATUS]** ✅ OPERATIONAL  
**[NEURAL_CORE]** ✅ READY  
**[ACCESS_LEVEL]** 🔓 UNRESTRICTED  
**[OPERATOR]** 👤 RedactMe  

*Welcome to the Neural Network Infiltration System* 