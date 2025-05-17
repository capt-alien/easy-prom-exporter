build:
	go build -o easy-prom-exporter
	sudo mv easy-prom-exporter /usr/local/bin/easy-prom-exporter
	sudo chmod +x /usr/local/bin/easy-prom-exporter
	sudo systemctl restart easy-prom-exporter

build-arm:
	GOARCH=arm64 GOOS=linux go build -o easy-prom-exporter

run:
	go run main.go

tidy:
	go mod tidy

vet:
	go vet .

clean:
	rm -f easy-prom-exporter
