# 🐳 DEDSEC AI - Docker Deployment

```
██████╗  ██████╗  ██████╗██╗  ██╗███████╗██████╗ 
██╔══██╗██╔═══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗
██║  ██║██║   ██║██║     █████╔╝ █████╗  ██████╔╝
██║  ██║██║   ██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗
██████╔╝╚██████╔╝╚██████╗██║  ██╗███████╗██║  ██║
╚═════╝  ╚═════╝  ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
```

**Neural Network Infiltration System - Container Deployment**  
**Operator:** RedactMe  
**Port:** 7443  
**Auto-Restart:** ✅ Always

## 🚀 Quick Start

### Option 1: One-Command Deployment (Recommended)
```bash
# Make the deployment script executable
chmod +x deploy-docker.sh

# Start Dedsec AI
./deploy-docker.sh start
```

### Option 2: Manual Docker Compose
```bash
# Start in production mode
docker compose up -d

# Or using legacy docker-compose
docker-compose up -d
```

### Access Your Application
```
🌐 http://localhost:7443
```

## 📋 Docker Setup Files

| File | Purpose |
|------|---------|
| `Dockerfile` | Multi-stage container definition with security |
| `docker-compose.yml` | Production orchestration with auto-restart |
| `docker-start.sh` | Container startup script with Dedsec branding |
| `deploy-docker.sh` | Deployment management script |
| `.dockerignore` | Build optimization and security |

## 🛠️ Container Management

### Using the Deployment Script
```bash
# Start containers
./deploy-docker.sh start

# Stop containers
./deploy-docker.sh stop

# Restart containers
./deploy-docker.sh restart

# View logs
./deploy-docker.sh logs

# Check status
./deploy-docker.sh status

# Development mode
./deploy-docker.sh dev

# Clean up everything
./deploy-docker.sh clean

# Build new image
./deploy-docker.sh build
```

### Using Docker Compose Directly
```bash
# Start services
docker compose up -d

# Stop services
docker compose down

# View logs
docker compose logs -f dedsec-ai

# Restart specific service
docker compose restart dedsec-ai

# Build and start
docker compose up -d --build

# Remove everything
docker compose down --rmi all --volumes
```

## 🔧 Configuration Details

### Container Features
- ✅ **Auto-restart:** `restart: always`
- ✅ **Health checks:** Built-in monitoring
- ✅ **Security:** Non-root user (`redactme:dedsec`)
- ✅ **Optimized:** Multi-stage build
- ✅ **Logging:** JSON file driver with rotation
- ✅ **Network:** Isolated bridge network

### Environment Variables
```yaml
NODE_ENV: production
PORT: 7443
HOSTNAME: 0.0.0.0
```

### Container Labels
```yaml
com.dedsec.ai.description: Neural Network Infiltration System
com.dedsec.ai.operator: RedactMe
com.dedsec.ai.version: 2.1.0
com.dedsec.ai.port: 7443
```

## 🔄 Development Mode

For development with hot reloading:

```bash
# Enable development mode
./deploy-docker.sh dev

# Access development server
# 🌐 http://localhost:3000
```

Development features:
- ✅ Hot reloading
- ✅ Volume mounting
- ✅ Development dependencies
- ✅ Source code changes reflected instantly

## 📊 Monitoring & Logs

### View Real-time Logs
```bash
# All logs
docker compose logs -f

# Specific service logs
docker compose logs -f dedsec-ai

# Last 100 lines
docker compose logs --tail=100 dedsec-ai
```

### Container Status
```bash
# Check running containers
docker compose ps

# Detailed container info
docker inspect dedsec-ai-neural-core

# Resource usage
docker stats dedsec-ai-neural-core
```

### Health Checks
The container includes automatic health monitoring:
- **Endpoint:** `http://localhost:7443`
- **Interval:** 30 seconds
- **Timeout:** 10 seconds
- **Retries:** 3
- **Start Period:** 40 seconds

## 🐛 Troubleshooting

### Container Won't Start
```bash
# Check container logs
docker compose logs dedsec-ai

# Check build logs
docker compose build --no-cache

# Verify port availability
sudo lsof -i :7443
```

### Build Issues
```bash
# Clean build
docker compose build --no-cache --pull

# Prune Docker system
docker system prune -a

# Check Docker space
docker system df
```

### Permission Issues
```bash
# Reset Docker permissions
sudo chown -R $USER:$USER .

# Restart Docker service
sudo systemctl restart docker
```

### Port Already in Use
```bash
# Find process using port 7443
sudo lsof -i :7443

# Kill process (replace PID)
sudo kill -9 <PID>

# Or use different port
docker compose up -d -p 8443:7443
```

## 🔐 Security Features

### Container Security
- ✅ **Non-root user:** Runs as `redactme` (UID 1001)
- ✅ **Read-only filesystem:** Application files protected
- ✅ **Limited capabilities:** Minimal permissions
- ✅ **Health monitoring:** Automatic failure detection
- ✅ **Network isolation:** Dedicated bridge network

### Image Security
- ✅ **Alpine Linux base:** Minimal attack surface
- ✅ **Multi-stage build:** No development dependencies
- ✅ **Clean image:** Optimized layers
- ✅ **Security scanning:** Regular updates

## 📈 Performance Optimization

### Resource Limits (Optional)
Add to `docker-compose.yml`:
```yaml
deploy:
  resources:
    limits:
      memory: 512M
      cpus: '0.5'
    reservations:
      memory: 256M
      cpus: '0.25'
```

### Volume Optimization
For persistent data:
```yaml
volumes:
  - dedsec-data:/app/data
```

## 🔄 Updates & Maintenance

### Update Application
```bash
# Pull latest changes
git pull

# Rebuild and restart
./deploy-docker.sh build
./deploy-docker.sh restart
```

### Update Base Image
```bash
# Pull latest Node.js image
docker pull node:20-alpine

# Rebuild with latest base
docker compose build --no-cache --pull
```

### Backup Container Data
```bash
# Export container
docker export dedsec-ai-neural-core > dedsec-ai-backup.tar

# Save image
docker save dedsec-ai > dedsec-ai-image.tar
```

## 🌐 Network Configuration

### Custom Network
The setup creates a dedicated network:
- **Name:** `dedsec-neural-network`
- **Type:** Bridge
- **Isolation:** Container-to-container communication

### External Access
```bash
# Access from other machines (replace with your IP)
http://192.168.1.100:7443
```

### Reverse Proxy (Nginx/Traefik)
For production with SSL:
```yaml
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.dedsec.rule=Host(`dedsec.example.com`)"
  - "traefik.http.routers.dedsec.tls.certresolver=letsencrypt"
```

## 📊 System Requirements

### Minimum Requirements
- **RAM:** 512MB available
- **CPU:** 1 core
- **Disk:** 2GB available space
- **Docker:** 20.10.0+
- **Docker Compose:** 1.29.0+

### Recommended Requirements
- **RAM:** 1GB available
- **CPU:** 2 cores
- **Disk:** 5GB available space
- **SSD:** For better performance

## 🎯 Production Deployment

### Environment Setup
```bash
# Set production environment
export NODE_ENV=production

# Start with production compose
docker compose -f docker-compose.yml up -d
```

### SSL/HTTPS Setup
Use a reverse proxy like Nginx or Traefik for SSL termination.

### Monitoring Integration
Integrate with monitoring solutions:
- **Prometheus:** Metrics collection
- **Grafana:** Visualization
- **Loki:** Log aggregation

---

**[SYSTEM_STATUS]** ✅ CONTAINERIZED  
**[NEURAL_CORE]** ✅ DOCKER READY  
**[AUTO_RESTART]** ✅ ENABLED  
**[OPERATOR]** 👤 RedactMe  

*Welcome to the Dockerized Neural Network Infiltration System* 