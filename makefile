# Build the Go binary
build:
	go build -o easy-prom-exporter

# Run the Go app directly
run:
	go run main.go

# Clean up built binaries
clean:
	rm -f easy-prom-exporter

# Run linter
vet:
	go vet .

# Sync go.mod and go.sum
tidy:
	go mod tidy

# Cross-compile for ARM64 (Pi)
build-arm:
	GOARCH=arm64 GOOS=linux go build -o easy-prom-exporter
