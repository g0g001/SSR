#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

#Check Root
[ $(id -u) != "0" ] && { echo "${CFAILURE}Error: You must be root to run this script${CEND}"; exit 1; }

#Set DNS
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf

#Disable selinux
if [ -s /etc/selinux/config ] && grep 'SELINUX=enforcing' /etc/selinux/config; then
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
    setenforce 0
fi

clear
#设置服务器时区为UTC+8  上海时间
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

#InstallBasicPackages
apt-get update -y
apt-get install git tar python unzip bc python-m2crypto curl gcc swig automake make perl cpio build-essential iptables -y
apt-get install language-pack-zh-hans -y

#下载文件
git clone https://github.com/g0g001/SSR

#Clone Something
cd /usr/local
mv /root/SSR/shadowsocks.tar.gz /usr/local/shadowsocks.tar.gz
tar -xf shadowsocks.tar.gz && cd shadowsocks

#
cd /usr/local
mv /root/SSR/SSR-Bash.tar.gz /usr/local/SSR-Bash.tar.gz
tar -xf SSR-Bash.tar.gz && cd SSR-Bash

#Intall libsodium
cd /root
mv /root/SSR/libsodium-1.0.10.tar.gz /root/libsodium-1.0.10.tar.gz
Cannot open: No such file or directory libsodium-1.0.10.tar.gz && cd libsodium-1.0.10
./configure && make && make install
echo "/usr/local/lib" > /etc/ld.so.conf.d/local.conf && ldconfig
cd ../ && rm -rf libsodium* 

#Install ssr-chkconfig
mkdir -p /etc/init.d/shadowsocksr
mv /root/SSR/ssr-chkconfig /etc/init.d/shadowsocksr/ssr-chkconfig
chmod +x /etc/init.d/shadowsocksr
update-rc.d -f shadowsocksr defaults

#Install Softlink
mv /root/SSR/ssr /usr/local/bin/ssr
chmod +x /usr/local/bin/ssr

echo '安装完成！输入 ssr 即可使用本程序~'
echo '欢迎加QQ群：277717865 讨论交流哦~'
