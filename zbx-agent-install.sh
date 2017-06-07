#!/bin/bash
read -p "Input hostname you want to change : " NewName

rm -rf /etc/zabbix/*.sh*
rm -rf /etc/zabbix/*.conf*
rm -rf /etc/zabbix/zabbix_agentd.d/*
yum install net-tools bind-utils wget -y
rpm -Uvh http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-agent-3.2.6-1.el7.x86_64.rpm
chkconfig zabbix-agent on

setenforce 0
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config

curl -s https://raw.githubusercontent.com/nickchangs/zabbix-agent2/master/ngx_status.sh -o "/etc/zabbix/ngx_status.sh"
curl -s https://raw.githubusercontent.com/nickchangs/zabbix-agent2/master/connections.sh -o "/etc/zabbix/connections.sh"
curl -s https://raw.githubusercontent.com/nickchangs/zabbix-agent2/master/access_status.sh -o "/etc/zabbix/access_status.sh"
curl -s https://raw.githubusercontent.com/nickchangs/zabbix-agent2/master/access_status.sh -o "/etc/zabbix/splunk_access.sh"
curl -s https://raw.githubusercontent.com/nickchangs/zabbix-agent2/master/access_status.sh -o "/etc/zabbix/splunk_netstat.sh"
curl -s https://raw.githubusercontent.com/nickchangs/zabbix-agent2/master/ip_connection_count.sh -o "/etc/zabbix/ip_connection_count.sh"
curl -s https://raw.githubusercontent.com/nickchangs/zabbix-agent2/master/zabbix_agentd.conf -o "/etc/zabbix/zabbix_agentd.conf"
curl -s https://raw.githubusercontent.com/nickchangs/zabbix-agent2/master/userparameter_nginx -o "/etc/zabbix/zabbix_agentd.d/userparameter_nginx.conf"
curl -s https://raw.githubusercontent.com/nickchangs/zabbix-agent2/master/zabbix_agentd.psk -o "/etc/zabbix/zabbix_agentd.psk"
curl -s https://raw.githubusercontent.com/nickchangs/zabbix-agent2/master/userparameter_ip.conf -o "/etc/zabbix/zabbix_agentd.d/userparameter_ip.conf"
chmod +x /etc/zabbix/*.sh

#if Agent is passive mode
#sed -i "s/Server=127.0.0.1/Server=61.216.144.186/g" /etc/zabbix/zabbix_agentd.conf
#sed -i "s/# ListenPort=10050/ListenPort=9345/g" /etc/zabbix/zabbix_agentd.conf

#if Agent is active mode
#sed -i "s/ServerActive=127.0.0.1/ServerActive=61.216.144.184:10051/g" /etc/zabbix/zabbix_agentd.conf
#echo "StartAgents=0"  >> /etc/zabbix/zabbix_agentd.conf
#echo "RefreshActiveChecks=60" >> /etc/zabbix/zabbix_agentd.conf
#echo "UserParameter=nginx.status[*],/etc/zabbix/ngx_status.sh \$1" >> /etc/zabbix/zabbix_agentd.conf
#echo "UserParameter=netstat.stat[*],(netstat -ant |grep -i $1|wc -l)" >> /etc/zabbix/zabbix_agentd.conf
#echo "UserParameter=access.status[*],/etc/zabbix/access_status.sh \$1" >> /etc/zabbix/zabbix_agentd.conf
echo Hostname=$NewName >> /etc/zabbix/zabbix_agentd.conf
systemctl enable zabbix-agent
service zabbix-agent restart
