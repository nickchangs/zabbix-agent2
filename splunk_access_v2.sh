#!/bin/bash
#這個script是用來計算四個服務的access IP和netstat的狀態，並丟到SPLUNK分析
#此程式服務器必需安裝NC及net-tools，HOSTNAME是抓zabbix-agent.conf裡面的資訊
#AccessIPList寫到/TMP/裡後，只有APP會加總進行統計後抓出CLIENT IP數量
#先將各NETSTAT抓一次到/TMP/裡面，再用語法抓出來各資訊
#請確認目前log file的大小，一定要logrotate有在執行，只存1天的LOG，其他是被壓縮起來的，不會會造成DISK I/O問題

Hostname=`cat /etc/zabbix/zabbix_agentd.conf | grep Hostname= | grep -v "#"`
netstat -antu > /tmp/netstat.log
LogFile='/tmp/netstat.log'
                var_ip=`cat $LogFile |awk ' $5 ~ /^[0-9]/ {print $5}' | grep -v "0.0.0.0\|169.254.169.254" | cut -d: -f1 | sort | uniq -c | sort -n | wc -l`
                var_list=`cat $LogFile |grep -i LISTEN|wc -l`
                var_ESTABLISHED=`cat $LogFile |grep -i ESTABLISHED|wc -l`
                var_SYN_RECV=`cat $LogFile |grep -i SYN_RECV|wc -l`
                var_SYN_SENT=`cat $LogFile |grep -i SYN_SENT|wc -l`
                var_TIME_WAIT=`cat $LogFile |grep -i TIME_WAIT|wc -l`
                var_CLOSE_WAIT=`cat $LogFile |grep -i CLOSE_WAIT|wc -l`
                var_FIN_WAIT1=`cat $LogFile |grep -i FIN_WAIT1|wc -l`
                var_FIN_WAIT2=`cat $LogFile |grep -i FIN_WAIT2|wc -l`
                var_CLOSING=`cat $LogFile |grep -i CLOSING|wc -l`
                var_Foreign=`cat $LogFile |grep -i Foreign|wc -l`
                var_LAST_ACK=`cat $LogFile |grep -i LAST_ACK|wc -l`
                #var_top_IPs=`cat $LogFile |awk ' $5 ~ /^[0-9]/ {print $5}' | cut -d: -f1 | sort | uniq -c | sort -nr | head -n10 | awk '{print $2}'| tr  '\n'  ' '`
                var_top_ip=`cat $LogFile |awk ' $5 ~ /^[0-9]/ {print $5}' | cut -d: -f1 | sort | uniq -c | sort -nr | head -n1 | awk '{print $2}'`
echo "Type=access,$Hostname,connections=$var_ip,LISTEN=$var_list,ESTABLISHED=$var_ESTABLISHED,SYN_RECV=$var_SYN_RECV,SYN_SENT=$var_SYN_SENT,LAST_ACK=$var_LAST_ACK,TIME_WAIT=$var_TIME_WAIT,CLOSE_WAIT=$var_CLOSE_WAIT,FIN_WAIT1=$var_FIN_WAIT1,FIN_WAIT2=$var_FIN_WAIT2,CLOSING=$var_CLOSING,Foreign=$var_Foreign,top_IP=$var_top_ip" | nc 61.216.144.184 -u 514 -w 1
cat /tmp/netstat.log |awk ' $5 ~ /^[0-9]/ {print $5}' | grep -v "0.0.0.0\|169.254.169.254" | cut -d: -f1 | sort | uniq -c | sort -nr | awk '{print $2}' | sed -e 's/^/client=/' | sed -e "s/^/$Hostname,/" | nc 61.216.144.184 -u 514 -w 1
