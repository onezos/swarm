#!/usr/bin/env bash
yum install -y vim
yum install -y wget
yum install -y curl
yum install -y epel-release
yum install -y jq
yum install -y lrzsz
yum install -y screen
yum install -y net-tools
wget -q -O - https://raw.githubusercontent.com/ethersphere/bee/master/install.sh | TAG=v0.6.2 bash
wget -O /root/cashout.sh https://gist.githubusercontent.com/ralph-pichler/3b5ccd7a5c5cd0500e6428752b37e975/raw/aa576d6d28b523ea6f5d4a1ffb3c8cc0bbc2677f/cashout.sh && chmod 777 /root/cashout.sh
wget -O /root/cha.sh https://download.swarmeth.org/centos/cha.sh && chmod a+x /root/cha.sh
wget -O /root/ds.sh https://download.swarmeth.org/centos/ds.sh && chmod a+x /root/ds.sh
wget -O /root/qidong.sh https://download.swarmeth.org/centos/qidong.sh && chmod a+x /root/qidong.sh
wget -O /root/mima.sh https://download.swarmeth.org/centos/mima.sh && chmod a+x /root/mima.sh
wget https://download.swarmeth.org/centos/password
mv password /home/
iptables -I INPUT -p tcp --dport 1635 -j ACCEPT
iptables -I INPUT -p tcp --dport 1634 -j ACCEPT
iptables -I INPUT -p tcp --dport 1635 -j ACCEPT
echo "请输入swap-endpoint链接，如https://goerli.infura.io/v3/12ecf******************:"
read ep
cat>/home/node1.yaml<<EOF
api-addr: :1633
block-time: "15"
bootnode:
- /dnsaddr/bootnode.ethswarm.org
config: /home/node1.yaml
cache-capacity: "1000000"
full-node: true
data-dir: /home/bee/node1
db-block-cache-capacity: "33554432"
db-disable-seeks-compaction: false
db-open-files-limit: "2000"
db-write-buffer-size: "33554432"
password-file: /home/password
debug-api-addr: :1635
debug-api-enable: true
p2p-addr: :1634
p2p-quic-enable: true
p2p-ws-enable: true
verbosity: 5
swap-enable: true
swap-initial-deposit: "10000000000000000"
#swap-endpoint: http://136.243.89.214:8545
swap-endpoint: ${ep}
welcome-message: "swarmeth团队欢迎您！"
EOF
/root/ds.sh
echo "    接到启动的gBZZ后，使用/root/qidong.sh或者bee start --config /home/node1.yaml启动"
rm -rf main.sh
rm -rf sub.sh
bee start --config /home/node1.yaml

