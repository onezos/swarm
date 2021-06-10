#!/usr/bin/env bash
ip=`ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"`
cntFile=".showcnt.txt"
if [ ! -f $cntFile ]; then
echo "未运行step1！"
exit
fi

tCnt=`cat $cntFile`
for ((i=1; i<=tCnt; i ++))
do
if [ ! -f /etc/systemd/system/bee${i}.service ]; then
cat >> /etc/systemd/system/bee${i}.service << EOF
[Unit]
Description=Bee Bzz Bzzzzz service
After=network.target
StartLimitIntervalSec=0
[Service]
Type=simple
Restart=always
RestartSec=60
User=root
LimitNOFILE=65536
ExecStart=/usr/local/bin/bee start  --config /root/node${i}.yaml
KillSignal=SIGINT Restart=on-failure
StandardOutput=append:/var/log/bee${i}.log
StandartError=append:/var/log/bee${i}-err.log
[Install]
WantedBy=multi-user.target
EOF
echo '服务已安装成功'
else echo '服务已经存在'
fi

# 重新加载配置
systemctl daemon-reload

# 使bee服务生效
systemctl enable bee${i}

# 启动bee
systemctl start bee${i}

#显示状态
echo 'systemctl status bee${i}'
systemctl status bee${i}

echo "对第$i个节点添加自动提取。"
echo "00 02 * * * root /root/cashout${i}.sh cashout-all" >> /etc/crontab
done
