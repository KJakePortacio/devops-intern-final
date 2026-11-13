# Loki setup and verification

## Start the stack

From the repository root:

    sudo docker compose -f monitoring/docker-compose.yaml up -d
    sudo docker compose -f monitoring/docker-compose.yaml ps

The stack uses Loki 3.6.4, Promtail 3.6.4, and Grafana 12.3.0. Grafana's Loki data source URL is `http://loki:3100`.

## Log labels

Promtail discovers Docker containers and collects NGINX logs. The log streams include these labels:

- `job="nginx-app"`
- `container="nginx-slim-check"`
- `service="nginx-app"`

## Query and result

I requested a missing path and got an HTTP 404 response:

    curl -s -o /dev/null -w 'HTTP %{http_code}\n' http://localhost:8080/this-path-should-404
    HTTP 404

In Grafana Explore, I ran:

    {container="nginx-slim-check"} |= "404"

The query returned four NGINX access log entries with HTTP 404 status, including requests for `/this-path-should-404` and `/favicon.ico`. The Explore screenshot is saved at `docs/screenshots/loki-explore.png`.

## Issues encountered

- Loki initially reported that the pattern ingester was waiting for 15 seconds. After waiting, its readiness endpoint returned `ready`.
- The initial Promtail container-name pattern missed `nginx-slim-check`. I corrected the pattern, restarted Promtail, and verified the logs with a container-specific query.
- Promtail reached end of life in March 2026. This assessment requires Promtail, so this setup pins version 3.6.4. For a maintained deployment, migrate log collection to Grafana Alloy.
