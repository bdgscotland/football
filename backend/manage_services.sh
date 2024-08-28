#!/bin/bash

# Define the docker-compose file location
COMPOSE_FILE=docker-compose.yml

# List of microservices and their directories
SERVICES=("user-service" "match-service")  # Add more services as needed

# Kafka topics to create
KAFKA_TOPICS=("match-events")  # Add more topics as needed

# Function to start services
start_services() {
  echo "Starting services..."
  podman-compose -f $COMPOSE_FILE up -d
  
  for service in "${SERVICES[@]}"; do
    echo "Building Node.js service: $service..."
    cd $service
    npm install
    npm run build
    cd ..
  done
  
  echo "Creating Kafka topics..."
  create_kafka_topics
  
  echo "Restarting Node.js services with pm2..."
  for service in "${SERVICES[@]}"; do
    pm2 start $service/dist/main.js --name $service --env production
  done
  
  echo "Services started and Node.js services built and restarted."
}

# Function to stop services
stop_services() {
  echo "Stopping Node.js services with pm2..."
  pm2 stop all
  
  echo "Stopping services..."
  podman-compose -f $COMPOSE_FILE down
  
  echo "Services stopped."
}

# Function to create Kafka topics
create_kafka_topics() {
  echo "Creating Kafka topics..."
  for topic in "${KAFKA_TOPICS[@]}"; do
    podman exec -it backend_kafka_1 kafka-topics --create --topic "$topic" --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1
  done
  echo "Kafka topics created."
}

# Function to show status of services
status_services() {
  podman-compose -f $COMPOSE_FILE ps
  pm2 status
}

# Function to reset everything to factory settings
factory_settings() {
  echo "Stopping all running containers..."
  podman stop $(podman ps -q)
  
  echo "Removing all containers..."
  podman rm -f $(podman ps -aq)
  
  echo "Removing all volumes..."
  podman volume rm $(podman volume ls -q)
  
  echo "Removing all images..."
  podman rmi -f $(podman images -q)
  
  for service in "${SERVICES[@]}"; do
    echo "Clearing Node.js build for: $service..."
    cd $service
    rm -rf dist
    rm -rf node_modules
    cd ..
  done
  
  echo "Everything has been reset to factory settings."
}

# Function to clean up unused images and containers
clean_up() {
  echo "Cleaning up unused containers, images, and volumes..."
  podman system prune -f
  echo "Cleanup complete."
}

# Function to show help
show_help() {
  echo "Usage: $0 {start|stop|status|restart|factorysettings}"
  echo "start          - Start all services and build/restart Node.js services"
  echo "stop           - Stop all services and Node.js services"
  echo "status         - Show status of running services and Node.js services"
  echo "restart        - Restart all services and rebuild/restart Node.js services"
  echo "factorysettings - Reset everything to factory settings"
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
  status)
    status_services
    ;;
  restart)
    stop_services
    clean_up
    start_services
    ;;
  factorysettings)
    factory_settings
    ;;
  *)
    show_help
    exit 1
    ;;
esac
