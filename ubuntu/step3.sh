tCnt=`cat .showcnt.txt`
ip=`ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"`
echo "ip,num,dpi_port,address,chequebook" > ${ip}.txt
mkdir -p keys
for ((i=1; i<=tCnt; i ++))
do
cp /var/lib/bee/node${i}/keys/swarm.key ./keys
mv ./keys/swarm.key ./keys/${ip}-${i}.key
dpi_port=`cat node${i}.yaml | grep 'debug-api-addr: 127.0.0.1:' | awk -F ':' '{print $3}'`
echo "节点${i}的端口为：${dpi_port}"
echo "节点${i}的钱包地址和合约地址:"
address=`curl -s localhost:${dpi_port}/addresses | jq .ethereum`
echo "address:${address}"
chequebook=`curl -s http://localhost:${dpi_port}/chequebook/address | jq .chequebookaddress`
echo "chequebook:${chequebook}"
echo "${ip},${i},${dpi_port},${address},${chequebook}" >> ${ip}.txt
done
sz ${ip}.txt
echo "下载密钥至本地……"
cp /var/lib/bee/password ./keys
mv ./keys/password ./keys/${ip}-password.txt
sz ./keys/*
rm -r ./keys
