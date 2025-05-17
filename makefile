# Run the exporter directly
run:
	go run main.go

# Build the binary
build:
	go build -o easy-prom-exporter

# Tidy up go.mod and go.sum
tidy:
	go mod tidy

# Lint with go vet
vet:
	go vet .

# Remove built binary
clean:
	rm -f easy-prom-exporter
