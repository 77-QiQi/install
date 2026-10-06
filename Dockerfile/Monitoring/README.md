# 使用

## 1. 设置环境变量

## 2. 编译容器，例："loveganyu/nezha:latest"

```
docker build $(grep -vE '^#|^$' .env | xargs -I {} echo "--build-arg {}") -t loveganyu/nezha:latest .
```

## 3. 推送至 Docker Hub （可选）

```
docker push loveganyu/nezha:latest
```
