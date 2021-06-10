#!/usr/bin/env bash
cntFile=".showcnt.txt"
epFile="epFile.txt"
if [ ! -f $cntFile ]; then
echo "首次使用脚本，进行初始化……"
sudo apt-get update
sudo apt-get install -y jq
sudo apt-get install -y lrzsz
sudo apt-get install -y screen
sudo apt-get install -y net-tools
wget https://download.swarmeth.org/v0.6.2/bee_0.6.2_amd64.deb
wget -O cashout.sh https://download.swarmeth.org/cashout/cashout.sh && chmod 777 cashout.sh
wget http://download.swarmeth.org/swarm/ubuntu/step2.sh && chmod 777 step2.sh
wget http://download.swarmeth.org/swarm/ubuntu/step3.sh && chmod 777 step3.sh
sudo dpkg -i bee_0.6.2_amd64.deb && sudo chown -R bee:bee /var/lib/bee
cd /root
echo "0" > $cntFile
chmod +rw $cntFile
sed -i 's/10000000000000000/1/g' cashout.sh
echo "请输入swap-endpoint链接，如https://goerli.infura.io/v3/12ecf******************:"
read ep
echo "${ep}" > $epFile
fi
if [ $# == 1 ]; then
if [ $1 == "resetcnt" ]; then
echo "0" > $cntFile
fi
fi
ep=`cat $epFile`
tCnt=`cat $cntFile`
let tCnt++
echo $tCnt > $cntFile
echo "    这是第 $tCnt 次创建节点"
echo "    若需更改endpoint，请自行修改epFile.txt"
cat>node${tCnt}.yaml<<EOF
api-addr: :$((1534+${tCnt}))
config: /root/node${tCnt}.yaml
data-dir: /var/lib/bee/node${tCnt}
cache-capacity: "2000000"
db-open-files-limit: "2000"
block-time: "15"
bootnode:
- /dnsaddr/bootnode.ethswarm.org
debug-api-addr: :$((1634+${tCnt}))
#debug-api-addr: 127.0.0.1:$((1634+${tCnt}))
debug-api-enable: true
p2p-addr: :$((1734+${tCnt}))
password-file: /var/lib/bee/password
swap-initial-deposit: "10000000000000000"
swap-deployment-gas-price: "650000000008"
verbosity: 3
swap-endpoint: ${ep}
full-node: true
welcome-message: "欢迎来到无产阶级社群，MY NAME IS DADAGUAI WECHAT:dislike_diss"
EOF
cp cashout.sh cashout${tCnt}.sh
sed -i "s/1635/$((1634+${tCnt}))/g" cashout${tCnt}.sh
echo "    第${tCnt}个节点等待接水中,node${tCnt}.yaml文件已生成至当前目录"
echo "    请等候bee与以太坊后端同步完毕后接水，然后按Ctrl+C"
echo "    之后可用./step1.sh再次运行此脚本部署更多节点"
echo "    部署完所有节点后运行step2.sh开始正式挖矿"
bee start --config node${tCnt}.yaml
