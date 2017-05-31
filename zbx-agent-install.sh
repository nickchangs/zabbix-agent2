#this is Bash install Zabbix Agent flow
#and Check servername and Hostname


#!/bin/bash
read -p "Input hostname you want to change : " NewName

rm -rf /etc/zabbix/zabbix_agentd.conf
yum install net-tools bind-utils wget -y
rpm -Uvh http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-agent-3.2.6-1.el7.x86_64.rpm
chkconfig zabbix-agent on

setenforce 0
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
wget https://www.dropbox.com/s/h44nyy2ylnqurvh/ngx_status.sh
wget https://www.dropbox.com/s/anhiq85hrac030p/access_status.sh
wget https://www.dropbox.com/s/3dayo61kyt31t6m/ip_connection_count.sh
mv *.sh /etc/zabbix/
chmod +x /etc/zabbix/*.sh

#if Agent is passive mode 
#sed -i "s/Server=127.0.0.1/Server=61.216.144.186/g" /etc/zabbix/zabbix_agentd.conf
#sed -i "s/# ListenPort=10050/ListenPort=9345/g" /etc/zabbix/zabbix_agentd.conf

#if Agent is active mode
sed -i "s/ServerActive=127.0.0.1/ServerActive=61.216.144.184:10051/g" /etc/zabbix/zabbix_agentd.conf
echo "StartAgents=0"  >> /etc/zabbix/zabbix_agentd.conf 
echo "RefreshActiveChecks=60" >> /etc/zabbix/zabbix_agentd.conf
echo "UserParameter=nginx.status[*],/etc/zabbix/ngx_status.sh \$1" >> /etc/zabbix/zabbix_agentd.conf
echo "UserParameter=netstat.stat[*],(netstat -ant |grep -i $1|wc -l)" >> /etc/zabbix/zabbix_agentd.conf
echo "UserParameter=access.status[*],/etc/zabbix/access_status.sh \$1" >> /etc/zabbix/zabbix_agentd.conf
HostName=`cat /etc/zabbix/zabbix_agentd.conf | grep Hostname= | grep -v "#"`
sed -i "s/$HostName/Hostname=$NewName/g" /etc/zabbix/zabbix_agentd.conf
systemctl enable zabbix-agent
service zabbix-agent restart

mkdir /var/log/ip_connection
echo "*/3 * * * * sh /etc/zabbix/ip_connection_count.sh" >> /var/spool/cron/root
service crond restart

#Check
rpm -qa | grep zabbix
ll /etc/zabbix/
tail -n 3 /etc/zabbix/zabbix_agentd.conf
ll /var/log/
cat /var/spool/cron/root
cat /etc/zabbix/zabbix_agentd.conf | grep Hostname=
rm -rf /root/test

stsList=`cat /opt/APP/openresty/nginx/conf/vhost/*.conf | grep server_name | grep -v "#"| sed "s/ /\n/g" | grep cdn > list`
Total=`cat list | wc -l`
for (( i=1 ; i<=$Total ; i=i+1 ))
do
        HostName=`cat list | head -n $i | tail -n 1`
        ping -c 1 -W 1 $HostName | awk '{print $3}' | tr -d "(" | tr -d ")" > Result
        HostIP=`head -n 1 Result`
        echo "$HostName be resolv IP : $HostIP"
done

rm -rf test list
