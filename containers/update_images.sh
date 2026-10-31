#!/usr/bin/env bash
set -euo pipefail

docker compose \
    -f compose.yaml \
    config \
    --lock-image-digests \
    -o compose.override.yaml



