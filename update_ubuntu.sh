#!/bin/bash


# sudo apt remove -y deja-dup open-vm-tools remmina libreoffice-common transmission-common aisleriot gnome-mahjongg gnome-mines gnome-sudoku rhythmbox thunderbird && sudo apt autoremove gnome-todo -y
# sudo apt-get autoremove


#  列出并卸载所有通过 snap 安装的软件
echo "卸载所有通过 snap 安装的软件..."
snap list --color=never | awk '/^-/{print $1}' | while read -r snapname; do
    if [ "$snapname" != "Name" ]; then
        echo "正在卸载 $snapname ..."
        sudo snap remove "$snapname"
    fi
done

#  卸载 snapd 服务
echo "卸载 snapd 服务..."
sudo apt remove --purge -y snapd

# 清理不再需要的依赖软件包
echo "清理不再需要的软件包..."
sudo apt autoremove -y

# 4删除 snapd 相关的配置文件和目录（慎用，可能会影响系统的其他部分）
echo "删除 snapd 相关的配置文件和目录..."
sudo rm -rf /var/cache/snapd/
sudo rm -rf ~/snap
sudo find / -type d -name "*snap*" -exec rm -rf {} + 2>/dev/null


rm -rf ~/snap
sudo rm -rf /snap
sudo rm -rf /var/snap
sudo rm -rf /var/lib/snapd


# 创建配置文件以阻止 apt 再次安装 snapd
echo "创建配置文件以阻止 apt 再次安装 snapd..."
cat <<EOF | sudo tee /etc/apt/preferences.d/nosnap.pref
Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF

echo "操作完成。"