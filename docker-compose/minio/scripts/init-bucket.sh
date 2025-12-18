#!/bin/sh
set -e

BUCKET="redpanda"

until mc alias set minio \
  "${MINIO_ENDPOINT}" \
  "${MINIO_ROOT_USER}" \
  "${MINIO_ROOT_PASSWORD}"
do
  echo "MinIO not ready yet, retrying..."
  sleep 1
done

echo "🪣 Creating bucket: ${BUCKET}"

mc mb --ignore-existing "minio/${BUCKET}"
mc anonymous set public "minio/${BUCKET}"

echo "Bucket ready"
exit