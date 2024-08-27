#!/bin/bash

# Define the docker-compose file location
COMPOSE_FILE=docker-compose.yml

# Load environment variables from .env file if it exists
if [ -f .env ]; then
  export $(cat .env | grep -v '#' | awk '/=/ {print $1}')
fi

# Function to build the Node.js services
build_services() {
  echo "Building Node.js services..."
  cd user-service
  npm run build
  cd ..
  echo "Build complete."
}

# Function to start services
start_services() {
  echo "Starting Docker Compose services..."
  podman-compose -f $COMPOSE_FILE up -d

  echo "Building and starting Node.js services with pm2..."
  build_services
  pm2 start ecosystem.config.js
  echo "All services started."
}

# Function to stop services
stop_services() {
  echo "Stopping Node.js services with pm2..."
  pm2 stop all

  echo "Stopping Docker Compose services..."
  podman-compose -f $COMPOSE_FILE down
  echo "All services stopped."
}

# Function to restart services
restart_services() {
  echo "Restarting all services..."
  stop_services
  start_services
  echo "All services restarted."
}

# Function to show status of services
status_services() {
  echo "Docker Compose services:"
  podman ps

  echo "Node.js services with pm2:"
  pm2 list
}

# Function to show help
show_help() {
  echo "Usage: $0 {start|stop|restart|status}"
  echo "start   - Start all services"
  echo "stop    - Stop all services"
  echo "restart - Restart all services"
  echo "status  - Show status of running services"
}

# Check for arguments
if [ $# -eq 0 ]; then
  show_help
  exit 1
fi

# Handle the command line arguments
case "$1" in
  start)
    start_services
    ;;
  stop)
    stop_services
    ;;
  restart)
    restart_services
    ;;
  status)
    status_services
    ;;
  *)
    show_help
    exit 1
    ;;
esac
