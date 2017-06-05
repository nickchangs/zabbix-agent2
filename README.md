1.1 第一次安裝
      請使用zbx-agent-install.sh這隻SCRIPT來安裝zabbix-agent, 安裝時請輸入Hostname,需要與SERVER上面的設定一樣的HOSTNAME

1.2 Agent加密設定
      請一次將一個品牌的xshell同時打開，再設定送命令到所有視窗方式，將以下設定貼到rp的cli執行
echo "TLSConnect=psk" >> /etc/zabbix/zabbix_agentd.conf
echo "TLSAccept=psk" >> /etc/zabbix/zabbix_agentd.conf
echo "TLSPSKFile=/etc/zabbix/zabbix_agentd.psk" >> /etc/zabbix/zabbix_agentd.conf
echo "TLSPSKIdentity=PSK 001" >> /etc/zabbix/zabbix_agentd.conf
curl -s https://raw.githubusercontent.com/nickchangs/zabbix-agent2/master/zabbix_agentd.psk -o "/etc/zabbix/zabbix_agentd.psk"
service zabbix-agent restart
