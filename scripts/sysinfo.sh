#!/usr/bin/env bash
set -euo pipefail

printf 'Current user: %s\n' "$(id -un)"
printf 'Effective UID: %s\n' "$(id -u)"
printf 'Hostname: %s\n' "$(hostname)"
printf 'Kernel release: %s\n' "$(uname -r)"
printf 'System date: %s\n' "$(date --iso-8601=seconds)"

printf '\nDisk usage:\n'
df -h /

printf '\nMemory usage:\n'
free -h

if command -v systemctl >/dev/null 2>&1; then
    if systemctl is-active --quiet docker; then
        docker_status='active'
    else
        docker_status='inactive'
    fi
elif command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
    docker_status='active'
else
    docker_status='unavailable'
fi

printf '\nDocker daemon status: %s\n' "$docker_status"
