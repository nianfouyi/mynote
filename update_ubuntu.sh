#!/bin/bash


sudo apt remove -y deja-dup open-vm-tools remmina libreoffice-common transmission-common aisleriot gnome-mahjongg gnome-mines gnome-sudoku rhythmbox thunderbird && sudo apt autoremove gnome-todo -y
sudo apt-get autoremove


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




# 创建配置文件以阻止 apt 再次安装 snapd
echo "创建配置文件以阻止 apt 再次安装 snapd..."
cat <<EOF | sudo tee /etc/apt/preferences.d/nosnap.pref
Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF

echo "操作完成。"

# 安装firfox

# 首先要判断哈是否有wget命令，没有的话需要先安装



# 检查wget是否已安装
if ! command -v wget &> /dev/null
then
    echo "wget could not be found, installing..."
    sudo apt update
    sudo apt install wget -y
else
    echo "wget is already installed."
fi


sudo install -d -m 0755 /etc/apt/keyrings

wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null

gpg -n -q --import --import-options import-show /etc/apt/keyrings/packages.mozilla.org.asc | awk '/pub/{getline; gsub(/^ +| +$/,""); if($0 == "35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3") print "\nThe key fingerprint matches ("$0").\n"; else print "\nVerification failed: the fingerprint ("$0") does not match the expected one.\n"}'

echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | sudo tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null


echo '
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
' | sudo tee /etc/apt/preferences.d/mozilla

sudo apt-get update && sudo apt-get install firefox
#
sudo apt-get install firefox-l10n-zh-cn

sudo apt update && sudo apt upgrade
sudo apt install -y curl gcc make build-essential
# need to test
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# install go 
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.22.2.linux-amd64.tar.gz

export PATH=$PATH:/usr/local/go/bin
go version