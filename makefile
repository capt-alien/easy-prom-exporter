ARCH := $(shell uname -m)

ifeq ($(ARCH),x86_64)
	GOARCH := amd64
else ifeq ($(ARCH),aarch64)
	GOARCH := arm64
else
	GOARCH := $(ARCH)
endif

build:
	GOARCH=$(GOARCH) GOOS=linux go build -o easy-prom-exporter
	sudo mv easy-prom-exporter /usr/local/bin/easy-prom-exporter
	sudo chmod +x /usr/local/bin/easy-prom-exporter
	sudo systemctl restart easy-prom-exporter

run:
	go run main.go

tidy:
	go mod tidy

vet:
	go vet .

clean:
	rm -f easy-prom-exporter
