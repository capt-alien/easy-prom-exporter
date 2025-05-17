# Easy Prometheus Exporter

A lightweight Prometheus exporter written in Go to monitor Vikunja's PVC mount health and disk usage.

Built to run as a systemd service on bare metal or as a sidecar inside a Kubernetes pod.

---

## 🔧 What It Does

- Exposes `simple_heartbeat` to confirm the exporter is alive
- Checks if Vikunja's PVC mount (`/mnt/ssd1`) is present
  → `vikunja_pvc_mount_available` = 1 if mounted, 0 if not
- (Coming Soon) Reports disk usage percent
  → `vikunja_pvc_usage_percent`

All metrics are available at:

```
http://<host>:2112/metrics
```

---

## 🚀 Run It

### Local (for dev/testing)

```bash
go run main.go
```

---

## 🛠️ Run as a systemd Service

### Install:

```bash
./install_service.sh
```

This will:
- Build and move the binary to `/usr/local/bin`
- Register a `systemd` unit
- Enable and start the service on boot

### Uninstall:

```bash
./uninstall_service.sh
```

This will:
- Stop the service
- Disable and delete the unit
- Optionally remove the binary

---

## 🐳 Coming Soon

- Docker container support
- K8s deployment as a sidecar to the Vikunja pod
- Additional metrics: free bytes, inodes used

---

## 📡 Prometheus Scrape Config Example

```yaml
- job_name: 'vikunja_exporter'
  static_configs:
    - targets: ['rp1:2112']
```

---

## 🧠 Author

Built by [capt-alien](https://github.com/capt-alien) as part of a home-lab monitoring stack powered by Prometheus, K3s, and Go.
