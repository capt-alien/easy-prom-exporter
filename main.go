package main

import (
	"net/http"
	"log"
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

var (
	simpleHeartbeat = prometheus.NewGauge(prometheus.GaugeOpts{
		Name: "simple_heartbeat",
		Help: "A basic metric that always reports 1 to show the exporter is alive",
	})
)

func main() {
	prometheus.MustRegister(simpleHeartbeat)
	simpleHeartbeat.Set(1)

	http.Handle("/metrics", promhttp.Handler())
	log.Println("Starting server on :2112...")


	err := http.ListenAndServe(":2112", nil)
	if err != nil {
		log.Fatalf("Server failed: %v", err)
	}
}
