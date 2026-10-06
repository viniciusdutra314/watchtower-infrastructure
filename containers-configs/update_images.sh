#!/usr/bin/env bash
set -euo pipefail

docker compose \
    -f compose.yaml \
    config \
    --lock-image-digests \
    -o compose.override.yaml

# Nextcloud AIO manages its own image updates and must not be digest-pinned.
sed -i \
    '/^  nextcloud-aio-mastercontainer:$/,/^    image: /d' \
    compose.override.yaml

docker compose config --quiet

