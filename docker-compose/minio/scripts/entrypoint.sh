#!/bin/sh
set -e

/scripts/init-bucket.sh

echo "🚀 MinIO initialization completed"

exec tail -f /dev/null
