# Easy Prometheus Exporter

A minimal custom Prometheus exporter written in Go.

## What it does

- Exposes a custom `simple_heartbeat` metric that always returns `1`
- Runs an HTTP server on `:2112/metrics` for Prometheus to scrape

## Run locally

```bash
go run main.go
