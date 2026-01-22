#!/usr/bin/env bash
set -euo pipefail

FFOLDER=${FFOLDER:-./ffolder}
if [ ! -d "$FFOLDER" ]; then
  echo "FFOLDER '$FFOLDER' does not exist. Create it and add files named after env vars (e.g. KAFKA_AUTO_CREATE_TOPICS)"
  exit 1
fi

echo "Loading env from $FFOLDER into current shell (exporting)..."
# shellcheck disable=SC2002
for f in "$FFOLDER"/*; do
  [ -f "$f" ] || continue
  key=$(basename "$f")
  val=$(cat "$f")
  export "$key"="$val"
done

echo "Exported environment variables from $FFOLDER"