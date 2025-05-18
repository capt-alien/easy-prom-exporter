FROM golang:1.22-alpine AS builder

WORKDIR /app
COPY . .

RUN go build -o easy-prom-exporter

#minimal image with just the binary
FROM alpine:latest

COPY --from=builder /app/easy-prom-exporter /usr/local/bin/easy-prom-exporter

EXPOSE 2112

ENTRYPOINT ["/usr/local/bin/easy-prom-exporter"]
