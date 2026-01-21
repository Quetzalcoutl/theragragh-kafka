#!/usr/bin/env bash
set -euo pipefail

# Usage: ./scripts/create-topic.sh my.topic 3 1
# Defaults: topic=test.topic partitions=1 replication=${KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR:-1}

TOPIC=${1:-test.topic}
PARTITIONS=${2:-1}
REPLICATION=${3:-${KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR:-1}}
COMPOSE_FILE=${COMPOSE_FILE:-docker-compose.prod.yml}
BROKER=${BROKER:-kafka:29092}

# Find kafka container name in this compose
KAFKA_CONTAINER=$(docker compose -f "${COMPOSE_FILE}" ps -q kafka || true)
if [ -z "${KAFKA_CONTAINER}" ]; then
  echo "Kafka container not found via compose (${COMPOSE_FILE}). Is the stack running?"
  exit 1
fi

echo "Creating topic '${TOPIC}' partitions=${PARTITIONS} replication=${REPLICATION} on ${BROKER}..."

docker exec -i "${KAFKA_CONTAINER}" \
  kafka-topics --create --bootstrap-server "${BROKER}" \
    --replication-factor "${REPLICATION}" --partitions "${PARTITIONS}" --topic "${TOPIC}"

echo "Topic '${TOPIC}' created (or already exists)." 
