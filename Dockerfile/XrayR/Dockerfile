# Build go
FROM golang:1.25-alpine AS builder
WORKDIR /app
COPY . .
ENV CGO_ENABLED=0
RUN go mod download
RUN go build -v -o XrayR-Server -trimpath -ldflags "-s -w -buildid="

# Release
FROM  alpine
RUN  apk --update --no-cache add tzdata ca-certificates \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN mkdir /etc/XrayR-Server/
COPY --from=builder /app/XrayR-Server /usr/local/bin

ENTRYPOINT [ "XrayR-Server", "--config", "/etc/XrayR-Server/config.yml"]
