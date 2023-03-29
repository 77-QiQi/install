# 安装 Docker & Compose 便携版

## 使用

```
apt-get update && apt-get upgrade -y

apt-get install curl iptables -y

curl https://raw.githubusercontent.com/77-QiQi/install/main/docker/install-docker.sh -o install-docker.sh

source install-docker.sh
```

## 或

```
apt-get update && apt-get upgrade -y

apt-get install curl iptables -y

source <(curl -s -L https://raw.githubusercontent.com/77-QiQi/install/main/docker/install-docker.sh)
```
