#!/usr/bin/env bash
set -euo pipefail

# Simple deploy script for VM03 (no env file required - values in compose are inlined)
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
COMPOSE_FILE="${ROOT_DIR}/deploy/vm03/docker-compose.yml"

echo "Pulling images..."
docker compose -f "$COMPOSE_FILE" pull --ignore-pull-failures || true

# If you build engine on VM, uncomment the build line below and ensure a build context exists
# docker compose -f "$COMPOSE_FILE" build --pull

echo "Bringing up services..."
docker compose -f "$COMPOSE_FILE" up -d

# Optionally create important topics if the helper script exists
if [ -x "${ROOT_DIR}/scripts/create-topic.sh" ]; then
  echo "Creating example topic 'blockchain.events'..."
  (cd "${ROOT_DIR}" && ./scripts/create-topic.sh blockchain.events 3 1)
fi

echo "Deploy complete. Check 'docker compose ps' and logs."