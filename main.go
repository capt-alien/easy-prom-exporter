package main

import (
	"net/http"
	"log"
	"os"
	"syscall"
	"time"
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

var (
	simpleHeartbeat = prometheus.NewGauge(prometheus.GaugeOpts{
		Name: "simple_heartbeat",
		Help: "A basic metric that always reports 1 to show the exporter is alive",
	})

	pvcUsagePercent = prometheus.NewGauge(prometheus.GaugeOpts{
		Name: "vikunja_pvc_usage_percent",
		Help: "Percentage of disk space used on the Vikunja PVC mounted path",
	})

	pvcFreeBytes = prometheus.NewGauge(prometheus.GaugeOpts{
		Name: "vikunja_pvc_free_bytes",
		Help: "Number of free bytes available on the PVC mounted path",
	})

	pvcInodeUsagePercent = prometheus.NewGauge(prometheus.GaugeOpts{
		Name: "vikunja_pvc_inode_usage_percent",
		Help: "Percentage of inodes used on the PVC mounted path",
	})
)

func updatePVCStats(path string) {
	var stat syscall.Statfs_t
	err := syscall.Statfs(path, &stat)
	if err != nil {
		log.Printf("Error getting stats for %s: %v", path, err)
		pvcUsagePercent.Set(0)
		pvcFreeBytes.Set(0)
		pvcInodeUsagePercent.Set(0)
		return
	}

	total := float64(stat.Blocks) * float64(stat.Bsize)
	free := float64(stat.Bfree) * float64(stat.Bsize)
	used := total - free

	pvcUsagePercent.Set((used / total) * 100)
	pvcFreeBytes.Set(free)

	inodesTotal := float64(stat.Files)
	inodesFree := float64(stat.Ffree)
	inodesUsed := inodesTotal - inodesFree

	if inodesTotal > 0 {
		inodeUsagePercent := (inodesUsed / inodesTotal) * 100
		pvcInodeUsagePercent.Set(inodeUsagePercent)
	} else {
		pvcInodeUsagePercent.Set(0)
	}
}

func main() {
	// Load mount path from environment variable
	mountPath := os.Getenv("EXPORTER_PATH")
	if mountPath == "" {
		mountPath = "/data" // fallback default
	}
	log.Printf("Monitoring mount path: %s\n", mountPath)

	prometheus.MustRegister(simpleHeartbeat)
	prometheus.MustRegister(pvcUsagePercent)
	prometheus.MustRegister(pvcFreeBytes)
	prometheus.MustRegister(pvcInodeUsagePercent)

	simpleHeartbeat.Set(1)

	go func() {
		for {
			updatePVCStats(mountPath)
			time.Sleep(30 * time.Second)
		}
	}()

	http.Handle("/metrics", promhttp.Handler())
	log.Println("Starting server on :2112...")

	err := http.ListenAndServe(":2112", nil)
	if err != nil {
		log.Fatalf("Server failed: %v", err)
	}
}
