#!/bin/bash

set -euo pipefail

echo "☕️ Keeping the Mac awake..."
caffeinate -i -s &

CAFFEINATE_PID=$!

echo "🐳 Starting docker containers..."
docker compose up -d

docker compose ps
echo "🚀 Containers are up! Enjoy it!"
echo -e "To stop: \033[31mkill ${CAFFEINATE_PID} && docker compose down\033[0m"
