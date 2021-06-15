#!/bin/bash
#安装所需软件
yum install -y vim
yum install -y wget
yum install -y curl
yum install -y epel-release
yum install -y jq
yum install -y lrzsz
yum install -y screen
yum install -y net-tools
#删除系统中已存在的docker
yum remove docker \
               docker-client \
               docker-client-latest \
               docker-common \
               docker-latest \
               docker-latest-logrotate \
               docker-logrotate \
               docker-engine
#安装docker
yum install -y yum-utils \
device-mapper-persistent-data \
lvm2
yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce docker-ce-cli containerd.io
#启动docker
systemctl start docker
#安装docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.28.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
#创建数据文件夹
cd /
mkdir data
cd data
mkdir docker
cd docker
mkdir bee1 bee2 bee3 bee4 bee5
mkdir clef1 clef2 clef3 clef4 clef5
wget https://download.swarmeth.org/swarm/docker/.env
wget https://download.swarmeth.org/swarm/docker/docker-compose.yml
cd /data/docker/
#启动docker-bee
docker-compose up -d
echo "您的节点钱包地址是："
tCnt=5
for ((i=1; i<=tCnt; i ++))
do
var=`ls /data/docker/clef${i}/keystore`
echo "0x"${var##*-}
done
iptables -I INPUT -p tcp --dport 1793 -j ACCEPT
iptables -I INPUT -p tcp --dport 1794 -j ACCEPT
iptables -I INPUT -p tcp --dport 1795 -j ACCEPT
iptables -I INPUT -p tcp --dport 1893 -j ACCEPT
iptables -I INPUT -p tcp --dport 1894 -j ACCEPT
iptables -I INPUT -p tcp --dport 1895 -j ACCEPT
iptables -I INPUT -p tcp --dport 1993 -j ACCEPT
iptables -I INPUT -p tcp --dport 1994 -j ACCEPT
iptables -I INPUT -p tcp --dport 1995 -j ACCEPT
iptables -I INPUT -p tcp --dport 2093 -j ACCEPT
iptables -I INPUT -p tcp --dport 2094 -j ACCEPT
iptables -I INPUT -p tcp --dport 2095 -j ACCEPT
iptables -I INPUT -p tcp --dport 2193 -j ACCEPT
iptables -I INPUT -p tcp --dport 2194 -j ACCEPT
iptables -I INPUT -p tcp --dport 2195 -j ACCEPT
echo "接水后docker自动运行，查看节点运行日志请输入："
echo "第一个节点：docker-compose logs -f bee-1"
echo "第二个节点：docker-compose logs -f bee-2"
echo "之后每个节点替换最后一位数字"
echo "停止docker容器命令："
echo "docker-compose down"
echo "启动节点命令："
echo "docker-compose up -d"
echo "启动单节点："
echo "docker-compose up -d bee-1"