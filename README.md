# mynote

拉取镜像的进修需要使用全名，不然即使科学上网后也会拉不下来镜像
```shell
docker pull --platform arm64 k8s.gcr.io/kube-state-metrics/kube-state-metrics:v2.3.0
docker pull --platform arm64 prom/alertmanager:v0.24.0
docker pull --platform arm64 prom/alertmanager:v0.24.0
```
使用docker save 保存时，不要使用id，应该使用镜像：tag的形式，使用id保存镜像，重新load会有问题

## ubuntu移除snapd 
need to remove some dir
```shell
rm -rf ~/snap
sudo rm -rf /snap
sudo rm -rf /var/snap
sudo rm -rf /var/lib/snapd
```
```
#!/bin/bash

# 1. 列出并卸载所有通过 snap 安装的软件
echo "卸载所有通过 snap 安装的软件..."
snap list --color=never | awk '/^-/{print $1}' | while read -r snapname; do
    if [ "$snapname" != "Name" ]; then
        echo "正在卸载 $snapname ..."
        sudo snap remove "$snapname"
    fi
done

# 2. 卸载 snapd 服务
echo "卸载 snapd 服务..."
sudo apt remove --purge -y snapd

# 3. 清理不再需要的依赖软件包
echo "清理不再需要的软件包..."
sudo apt autoremove -y

# 4. 删除 snapd 相关的配置文件和目录（慎用，可能会影响系统的其他部分）
echo "删除 snapd 相关的配置文件和目录..."
sudo rm -rf /var/cache/snapd/
sudo rm -rf ~/snap
sudo find / -type d -name "*snap*" -exec rm -rf {} + 2>/dev/null

# 5. 创建配置文件以阻止 apt 再次安装 snapd
echo "创建配置文件以阻止 apt 再次安装 snapd..."
cat <<EOF | sudo tee /etc/apt/preferences.d/nosnap.pref
Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF

echo "操作完成。"
```
