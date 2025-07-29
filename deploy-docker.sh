#!/bin/bash

# DEDSEC AI - Docker Deployment Script
# Neural Network Infiltration System - Container Management

# Colors for terminal output
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions
log() {
    echo -e "${GREEN}[DOCKER] $1${NC}"
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

# ASCII Art Banner
echo -e "${GREEN}"
echo "██████╗  ██████╗  ██████╗██╗  ██╗███████╗██████╗ "
echo "██╔══██╗██╔═══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗"
echo "██║  ██║██║   ██║██║     █████╔╝ █████╗  ██████╔╝"
echo "██║  ██║██║   ██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗"
echo "██████╔╝╚██████╔╝╚██████╗██║  ██╗███████╗██║  ██║"
echo "╚═════╝  ╚═════╝  ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝"
echo -e "${NC}"
echo -e "${CYAN}Dedsec AI - Docker Deployment Manager${NC}"
echo -e "${CYAN}Operator: RedactMe | Port: 7443${NC}"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    error "Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    error "Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Function to show usage
show_usage() {
    echo -e "${YELLOW}Usage: $0 [COMMAND]${NC}"
    echo ""
    echo "Commands:"
    echo "  start     - Start Dedsec AI containers"
    echo "  stop      - Stop Dedsec AI containers"
    echo "  restart   - Restart Dedsec AI containers"
    echo "  build     - Build Dedsec AI image"
    echo "  logs      - Show container logs"
    echo "  status    - Show container status"
    echo "  clean     - Remove containers and images"
    echo "  dev       - Start in development mode"
    echo ""
    echo "Examples:"
    echo "  $0 start     # Start production containers"
    echo "  $0 logs      # View logs"
    echo "  $0 dev       # Start development environment"
}

# Use docker compose v2 if available, fallback to docker-compose
COMPOSE_CMD="docker compose"
if ! docker compose version &> /dev/null; then
    COMPOSE_CMD="docker-compose"
fi

case "${1:-start}" in
    start)
        log "Starting Dedsec AI Neural Network..."
        $COMPOSE_CMD up -d
        if [ $? -eq 0 ]; then
            log "✓ Dedsec AI is now running on port 7443"
            info "Access: http://localhost:7443"
            info "Container: dedsec-ai-neural-core"
        else
            error "Failed to start containers"
            exit 1
        fi
        ;;
    
    stop)
        log "Stopping Dedsec AI Neural Network..."
        $COMPOSE_CMD down
        log "✓ Containers stopped"
        ;;
    
    restart)
        log "Restarting Dedsec AI Neural Network..."
        $COMPOSE_CMD restart
        log "✓ Containers restarted"
        ;;
    
    build)
        log "Building Dedsec AI container image..."
        $COMPOSE_CMD build --no-cache
        log "✓ Image built successfully"
        ;;
    
    logs)
        log "Showing Dedsec AI logs..."
        $COMPOSE_CMD logs -f dedsec-ai
        ;;
    
    status)
        log "Dedsec AI Container Status:"
        $COMPOSE_CMD ps
        echo ""
        info "Network Status:"
        docker network ls | grep dedsec
        ;;
    
    clean)
        warning "This will remove all Dedsec AI containers and images"
        read -p "Are you sure? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            log "Cleaning up Dedsec AI deployment..."
            $COMPOSE_CMD down --rmi all --volumes --remove-orphans
            log "✓ Cleanup complete"
        else
            info "Cleanup cancelled"
        fi
        ;;
    
    dev)
        log "Starting Dedsec AI in development mode..."
        # Uncomment the dev service in docker-compose.yml
        sed -i 's/# dedsec-ai-dev:/dedsec-ai-dev:/' docker-compose.yml
        sed -i 's/#   build:/  build:/' docker-compose.yml
        sed -i 's/#     context:/    context:/' docker-compose.yml
        sed -i 's/#     dockerfile:/    dockerfile:/' docker-compose.yml
        sed -i 's/#     target:/    target:/' docker-compose.yml
        sed -i 's/#   container_name:/  container_name:/' docker-compose.yml
        sed -i 's/#   restart:/  restart:/' docker-compose.yml
        sed -i 's/#   ports:/  ports:/' docker-compose.yml
        sed -i 's/#     - "3000:3000"/    - "3000:3000"/' docker-compose.yml
        sed -i 's/#   volumes:/  volumes:/' docker-compose.yml
        sed -i 's/#     - \.:/    - .:/' docker-compose.yml
        sed -i 's/#     - \/app\/node_modules/    - \/app\/node_modules/' docker-compose.yml
        sed -i 's/#   environment:/  environment:/' docker-compose.yml
        sed -i 's/#     - NODE_ENV=development/    - NODE_ENV=development/' docker-compose.yml
        sed -i 's/#     - PORT=3000/    - PORT=3000/' docker-compose.yml
        sed -i 's/#   networks:/  networks:/' docker-compose.yml
        sed -i 's/#     - dedsec-network/    - dedsec-network/' docker-compose.yml
        
        $COMPOSE_CMD up -d dedsec-ai-dev
        if [ $? -eq 0 ]; then
            log "✓ Dedsec AI development environment running on port 3000"
            info "Access: http://localhost:3000"
            info "Hot reloading enabled"
        else
            error "Failed to start development environment"
            exit 1
        fi
        ;;
    
    help|--help|-h)
        show_usage
        ;;
    
    *)
        error "Unknown command: $1"
        show_usage
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}[NEURAL_CORE] Operation complete${NC}"
echo -e "${CYAN}[OPERATOR] RedactMe${NC}" 