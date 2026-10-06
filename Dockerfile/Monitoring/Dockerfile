# ==========================================
# Builder
# ==========================================
FROM golang:1.27-trixie AS builder

ARG GITHUB_BRANCH
ARG GITHUB_URL
ARG IPINFO

WORKDIR /app

# 安装必要的系统工具
RUN apt-get update && apt-get install -y --no-install-recommends git bash curl wget unzip && rm -rf /var/lib/apt/lists/*

# 拉取源码
RUN git clone -b ${GITHUB_BRANCH} ${GITHUB_URL} .

# 安装 yq (yq_linux_amd64)
RUN wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq && chmod +x /usr/bin/yq

# 安装 Swagger 命令行工具 (swag)
RUN go install github.com/swaggo/swag/cmd/swag@latest

# 拉取前端资源（依赖 bash, curl, unzip, yq）
RUN chmod +x ./script/fetch-frontends.sh && ./script/fetch-frontends.sh

# 下载 IP 数据库
RUN rm pkg/geoip/geoip.db && wget -O pkg/geoip/geoip.db "${IPINFO}"

# 下载 Go 依赖
RUN go mod download

# 生成 Swagger API 文档
RUN swag init --pd -d cmd/dashboard -g main.go -o cmd/dashboard/docs

# 编译（nezha-dashboard）
RUN go build -v -o nezha-dashboard -trimpath -ldflags "-s -w -buildid=" ./cmd/dashboard


# ==========================================
# Release
# ==========================================
FROM debian:trixie-slim

ARG TZ=Asia/Shanghai
ENV TZ=$TZ

# 安装必要依赖
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates tzdata && rm -rf /var/lib/apt/lists/*

# 从 Builder 中仅复制 entrypoint.sh 文件
COPY --from=builder /app/script/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /dashboard

# 从 Builder 中仅复制编译好的二进制文件
COPY --from=builder /app/nezha-dashboard ./app

VOLUME ["/dashboard/data"]
EXPOSE 8008

ENTRYPOINT ["/entrypoint.sh"]
