# 使用

## 1. 获取域名及VPS(注意可用的存储空间)


## 2. 安装 Docker & Compose

```
apt-get update && apt-get upgrade -y

apt-get install curl -y

source <(curl -s -L https://raw.githubusercontent.com/77-QiQi/install/main/docker/install-docker.sh)
```


## 3. 创建工作目录并下载 docker-compose.yml 文件

```
mkdir -p /opt/cloud

cd /opt/cloud/

curl https://raw.githubusercontent.com/77-QiQi/install/main/nextcloud/docker-compose.yml -o docker-compose.yml
```

## 4. 编辑 docker-compose.yml 文件，设置与数据库相关的环境变量并创建容器

```
nano docker-compose.yml

docker-compose up -d
```

## 5. 参考 nginx.org <a href="https://nginx.org/en/linux_packages.html">文档</a> 安装NGINX并设置TLS及反向代理（或者通过其他方式设置TLS及反向代理）

```
mariadb 监听本地 3306 端口（不开放公网访问）
nextcloud 监听本地 8080 端口（不开放公网访问）
phpmyadmin 监听本地 180 端口（不开放公网访问）
```

## 6. 访问你的域名并设置管理员账号密码

其他设置，请参考 Nextcloud <a href="https://docs.nextcloud.com/server/latest/admin_manual/contents.html">文档</a>

### 可选的设置一

添加到 nextcloud/config/config.php

开启反向代理后设置：
```
'overwriteprotocol' => 'https',
```

不检查 .well-known 设置：
```
'check_for_working_wellknown_setup' => false,
```

隐藏“获取您自己的免费帐户”：
```
'simpleSignUpLink.shown' => false,
```

设置电话号码默认区域：
```
'default_phone_region' => 'CN',
```

活动记录的保留天数：
```
'activity_expire_days' => 365,
'activity_use_cached_mountpoints' => true,
```

自动扫描文件夹（除外部储存）:
```
'filesystem_check_changes' => 1,
```

Transactional File Locking:
```
'filelocking.enabled' => true,
'memcache.locking' => '\OC\Memcache\Redis',
```

Redis:
```
'memcache.distributed' => '\OC\Memcache\Redis',
'redis' => array(
     'host' => 'redis',
     'port' => 6379,
     'dbindex'  => 0,
     'timeout' => 0.0,
     'password' => '',
      ),
```

### 可选的设置二

运行 crontab -e 命令并设置 cron 任务：
```
crontab -e

*/5  *  *  *  * docker exec -u www-data nextcloud php /var/www/html/cron.php
```

nextcloud 容器内安装 aria2 ffmpeg:
```
docker exec nextcloud apt update
docker exec nextcloud apt install aria2 ffmpeg -y
```
