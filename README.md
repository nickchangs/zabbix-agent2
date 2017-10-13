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
 
      最後進入zabbix ui內，選config ==> host ==> 選一個品牌的group ==>全選 ==> MASS UPDATE ==> 選加密 (encr…) ==>全選psk ==> PSK 001 ==> zabbix_agentd.psk裡面的key  
 
      可以參考如下連結https://www.zabbix.com/documentation/3.2/manual/encryption/using_pre_shared_keys  
 
1.3 新增Zabbix Agent Userparameter

      curl -s https://raw.githubusercontent.com/nickchangs/zabbix-agent2/master/userparameter_ip.conf -o "/etc/zabbix/zabbix_agentd.d/userparameter_ip.conf"

      curl -s https://raw.githubusercontent.com/nickchangs/zabbix-agent2/master/connections.sh -o "/etc/zabbix/connections.sh"

      service zabbix-agent restart

      於Templete OS Linux Active 新增item 及 trigger

1.4 將連線數及netstat狀態數送給splunk

      curl -s https://raw.githubusercontent.com/nickchangs/zabbix-agent2/master/splunk_access.sh -o "/etc/zabbix/splunk_access.sh"

      yum install -y nc

      echo "*/5 * * * * sh /etc/zabbix/splunk_access.sh" > /var/spool/cron/root

1.5 安裝salt-minion自動化工具

      yum install https://repo.saltstack.com/yum/redhat/salt-repo-latest-2.el7.noarch.rpm -y

      yum install salt-minion -y

      systemctl enable salt-minion

      service salt-minion start

      echo "032-cp1-pay-01" > /etc/salt/minion_id

      echo "master: 61.216.144.184" >> /etc/salt/minion

      echo "tcp_keepalive: True" >> /etc/salt/minion

      echo "tcp_keepalive_idle: 60" >> /etc/salt/minion

      service salt-minion restart

1.6 新增ma維護程式
      APP:
      curl -s https://raw.githubusercontent.com/nickchangs/ma/master/ma_app_start.sh -o "/root/ma_app_start.sh"
      
      curl -s https://raw.githubusercontent.com/nickchangs/ma/master/ma_app_stop.sh -o "/root/ma_app_stop.sh"
      前台： 
      curl -s https://raw.githubusercontent.com/nickchangs/ma/master/ma_fe_start.sh -o "/root/ma_fe_start.sh"

      curl -s https://raw.githubusercontent.com/nickchangs/ma/master/ma_fe_stop.sh -o "/root/ma_fe_stop.sh"
