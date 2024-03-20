#!/bin/bash

# 源镜像仓库地址和认证信息
source_registry="source_registry_ip:port"
source_username="your_source_username"
source_password="your_source_password"

# 目标镜像仓库地址和认证信息
target_registry="target_registry_ip:port"
target_username="your_target_username"
target_password="your_target_password"

# 登录到源镜像仓库
docker login $source_registry -u $source_username -p $source_password

# 获取源镜像仓库中的所有镜像列表
images=$(curl -sS "https://$source_registry/v2/_catalog" | jq -r '.repositories[]')

# 登录到目标镜像仓库
docker login $target_registry -u $target_username -p $target_password

# 循环遍历并推送每个镜像到目标仓库
for image in $images
do
    docker pull $source_registry/$image
    docker tag $source_registry/$image $target_registry/$image
    docker push $target_registry/$image
done

# 完成后注销登录
docker logout $source_registry
docker logout $target_registry

echo "镜像仓库复制完成！"
