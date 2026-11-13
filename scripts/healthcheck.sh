#!/usr/bin/env bash
set -euo pipefail

target_url="${1:-http://localhost:8080}"

if [ "$#" -gt 1 ]; then
    printf 'Usage: %s [URL]\n' "$0" >&2
    exit 2
fi

if ! command -v curl >/dev/null 2>&1; then
    printf 'FAIL: curl is required but was not found\n' >&2
    exit 1
fi

if http_status=$(curl --silent --show-error --output /dev/null \
    --write-out '%{http_code}' --max-time 5 "$target_url"); then
    :
else
    printf 'FAIL: request to %s could not be completed\n' "$target_url" >&2
    exit 1
fi

if [ "$http_status" = '200' ]; then
    printf 'PASS: %s returned HTTP %s\n' "$target_url" "$http_status"
else
    printf 'FAIL: %s returned HTTP %s; expected 200\n' \
        "$target_url" "$http_status" >&2
    exit 1
fi
