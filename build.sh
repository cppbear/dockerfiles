#!/bin/bash
set -eo pipefail

# Configuration parameters
DOCKERHUB_USER=""             # Default DockerHub username (empty)
REPO_SUFFIX="dev"             # Image suffix
LOG_DIR="build-logs"   # Log directory

# Help message
show_help() {
  echo "Usage: $0 [OPTIONS] [PATH...]"
  echo "Build Docker images from Dockerfiles"
  echo
  echo "Options:"
  echo "  -h, --help     Show this help message"
  echo "  -u, --user     Set DockerHub username"
  echo "  -s, --suffix   Set image suffix (default: $REPO_SUFFIX)"
  echo "  -l, --logs     Set log directory (default: $LOG_DIR)"
  echo
  echo "Arguments:"
  echo "  PATH           Dockerfile path or directory (default: auto-discover)"
}

# Parse parameters
PATHS=()
while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      show_help
      exit 0
      ;;
    -u|--user)
      DOCKERHUB_USER="$2"
      shift; shift
      ;;
    -s|--suffix)
      REPO_SUFFIX="$2"
      shift; shift
      ;;
    -l|--logs)
      LOG_DIR="$2"
      shift; shift
      ;;
    -*)
      echo "Error: Unknown option $1" >&2
      exit 1
      ;;
    *)
      PATHS+=("$1")
      shift
      ;;
  esac
done

# Create log directory
mkdir -p "$LOG_DIR"

# Get absolute path
get_abs_path() {
  local path="$1"
  if [[ -d "$path" ]]; then
    (cd "$path" && pwd)
  else
    echo "$(cd "$(dirname "$path")" && pwd)/$(basename "$path")"
  fi
}

# Collect all Dockerfile paths
declare -A dockerfiles

# Process explicitly specified paths
if [[ ${#PATHS[@]} -gt 0 ]]; then
  for path in "${PATHS[@]}"; do
    abs_path=$(get_abs_path "$path")

    if [[ -f "$abs_path" && $(basename "$abs_path") =~ Dockerfile$ ]]; then
      dockerfiles["$abs_path"]=1
    elif [[ -d "$abs_path" ]]; then
      while IFS= read -r -d '' file; do
        dockerfiles["$file"]=1
      done < <(find "$abs_path" -type f \( -name "Dockerfile" -o -name "*.Dockerfile" \) -print0)
    else
      echo "Error: Invalid path $path" >&2
      exit 1
    fi
  done

# Auto-discovery mode
else
  echo "Discovering Dockerfiles in non-hidden directories..."
  while IFS= read -r -d '' file; do
    dockerfiles["$file"]=1
  done < <(find . -type f \( -name "Dockerfile" -o -name "*.Dockerfile" \) -not -path '*/.*' -print0)
fi

# Check if any Dockerfiles were found
if [[ ${#dockerfiles[@]} -eq 0 ]]; then
  echo "Error: No Dockerfiles found" >&2
  exit 1
fi

# Build function
build_image() {
  local dockerfile="$1"
  local context_dir=$(dirname "$dockerfile")
  local folder_name=$(basename "$context_dir")

  # Generate tag
  local raw_tag=$(basename "$dockerfile")
  local tag=$(echo "$raw_tag" | sed -E \
    -e 's/\.[^.]*$//' \
    -e 's/Dockerfile/latest/' \
    -e 's/[^a-zA-Z0-9_.-]/-/g')

  # Sanitize image name
  local sanitized_name=$(echo "$folder_name" | \
    tr '[:upper:]' '[:lower:]' | \
    tr -cd '[:alnum:]-_' | \
    sed 's/^[^a-zA-Z0-9]*//;s/[^a-zA-Z0-9]*$//')

  # Compose image name
  local image_prefix=""
  [[ -n "$DOCKERHUB_USER" ]] && image_prefix="${DOCKERHUB_USER}/"
  local image_name="${image_prefix}${sanitized_name}-${REPO_SUFFIX}:${tag}"

  # Generate log filename
  local log_file="${LOG_DIR}/build-${sanitized_name}-${tag}.log"

  echo "--------------------------------------------------"
  echo "Building:  $dockerfile"
  echo "Context:   $context_dir"
  echo "Image:     $image_name"
  echo "Log file:  $log_file"

  # Execute build and log output
  docker build \
    --file "$dockerfile" \
    --tag "$image_name" \
    "$context_dir" 2>&1 | tee "$log_file"
}

# Main build loop
for dockerfile in "${!dockerfiles[@]}"; do
  build_image "$dockerfile" || exit $?
done

echo "All builds completed successfully!"
