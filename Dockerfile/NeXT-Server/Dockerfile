# Build go
FROM golang:1.23.0-alpine AS builder
WORKDIR /app
COPY . .
ENV CGO_ENABLED=0
RUN go mod download
RUN go build -v -o NeXT-Server -trimpath -ldflags "-s -w -buildid="

# Release
FROM  alpine
RUN  apk --update --no-cache add tzdata ca-certificates \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN mkdir /etc/NeXT-Server/
COPY --from=builder /app/NeXT-Server /usr/local/bin

ENTRYPOINT [ "NeXT-Server", "--config", "/etc/NeXT-Server/config.yml"]
