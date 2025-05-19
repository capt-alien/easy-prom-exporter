# Easy Prometheus Exporter

A lightweight custom Prometheus exporter written in Go, containerized with Docker, and deployed as a sidecar in Kubernetes to monitor a Persistent Volume Claim (PVC).

---

## 📊 What It Exports

- `simple_heartbeat`: Confirms the exporter is alive
- `vikunja_pvc_usage_percent`: Percent of disk used on `/mnt/ssd1`
- `vikunja_pvc_free_bytes`: Free disk space on `/mnt/ssd1` (in bytes)
- `vikunja_pvc_inode_usage_percent`: Percent of inodes used on `/mnt/ssd1`

---

## 🚀 Local Dev

```bash
make build       # Build the binary for ARM
make deploy      # Move binary to /usr/local/bin and restart service
make run         # Run manually (or systemd takes over)
```

---

## 🐳 Docker

Build and push to GHCR:

```bash
docker build -t ghcr.io/capt-alien/easy-prom-exporter:latest .
docker push ghcr.io/capt-alien/easy-prom-exporter:latest
```

Run locally:

```bash
docker run -d \
  -p 2112:2112 \
  -v /mnt/ssd1:/mnt/ssd1:ro \
  ghcr.io/capt-alien/easy-prom-exporter:latest
```

---

## ☸️ Kubernetes Deployment (Sidecar)

This exporter is deployed as a **sidecar container** inside the Vikunja pod. It mounts the same PVC as Vikunja and exposes metrics via port `2112`.

Example container spec:

```yaml
- name: easy-prom-exporter
  image: ghcr.io/capt-alien/easy-prom-exporter:latest
  ports:
    - containerPort: 2112
  volumeMounts:
    - name: ssd1-mount
      mountPath: /mnt/ssd1
      readOnly: true
```

---

## 🔔 Prometheus Integration

Prometheus is configured with:

```yaml
- job_name: 'vikunja_exporter'
  scrape_interval: 15s
  static_configs:
    - targets: ['<pod_ip>:2112']
```

Or better: expose the pod with a `ClusterIP` service and scrape by DNS.

---

## 📦 Alerting

Alert rules include:

- PVC usage > 85%
- Inode usage > 90%
- Mount unavailable

Hooked into Alertmanager via local webhook (`localhost:5001/webhook`).

---

## 🧠 Maintainer Notes

- Built in Go 1.22
- Runs on ARM (`aarch64`)
- Uses native `syscall.Statfs` for disk and inode stats
