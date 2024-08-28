#!/bin/bash

# Load environment variables from .env file
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
else
  echo ".env file not found! Please create one with the necessary configuration."
  exit 1
fi

# Ensure that all required environment variables are set
if [[ -z "$DATABASE_USER" || -z "$DATABASE_NAME" || -z "$DATABASE_HOST" || -z "$DATABASE_PORT" ]]; then
  echo "One or more required environment variables are missing:"
  echo "DATABASE_USER: $DATABASE_USER"
  echo "DATABASE_NAME: $DATABASE_NAME"
  echo "DATABASE_HOST: $DATABASE_HOST"
  echo "DATABASE_PORT: $DATABASE_PORT"
  exit 1
fi

# Set the container name for the PostgreSQL container (adjust this if needed)
DB_CONTAINER_NAME="postgres-db"

# Function to execute SQL in the containerized PostgreSQL
exec_sql() {
  local sql_command="$1"
  podman exec -it "$DB_CONTAINER_NAME" psql -U "$DATABASE_USER" -d "$DATABASE_NAME" -c "$sql_command"
}

# Function to drop and recreate the schema
drop_and_recreate_schema() {
  echo "Dropping and recreating schema..."
  exec_sql "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"
  echo "Schema dropped and recreated successfully."
}

# Function to inspect the database for duplicate emails
inspect_duplicates() {
  echo "Inspecting for duplicate emails..."
  exec_sql 'SELECT "email", COUNT(*) FROM "user" GROUP BY "email" HAVING COUNT(*) > 1;'
  echo "Inspection complete."
}




# Show usage information
show_help() {
  echo "Usage: $0 {drop|inspect}"
  echo "drop    - Drop and recreate the database schema"
  echo "inspect - Inspect the database for duplicate emails"
}

# Check for arguments
if [ $# -eq 0 ]; then
  show_help
  exit 1
fi

# Handle the command line arguments
case "$1" in
  drop)
    drop_and_recreate_schema
    ;;
  inspect)
    inspect_duplicates
    ;;
  *)
    show_help
    exit 1
    ;;
esac
