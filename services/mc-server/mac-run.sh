#!/bin/bash

set -euo pipefail

echo "☕️ Keeping the Mac awake..."
caffeinate -i -s &

CAFFEINATE_PID=$!

echo "🐳 Starting docker containers..."
docker compose up -d

echo "🚀 Containers are up! Enjoy it!"
echo -e "To stop caffeinate: \033[31mkill ${CAFFEINATE_PID}\033[0m"

