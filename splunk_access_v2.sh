#!/bin/bash
#這個script是用來計算四個服務的access IP和netstat的狀態，並丟到SPLUNK分析
#此程式服務器必需安裝NC及net-tools，HOSTNAME是抓zabbix-agent.conf裡面的資訊
#AccessIPList寫到/TMP/裡後，只有APP會加總進行統計後抓出CLIENT IP數量
#先將各NETSTAT抓一次到/TMP/裡面，再用語法抓出來各資訊
#請確認目前log file的大小，一定要logrotate有在執行，只存1天的LOG，其他是被壓縮起來的，不會會造成DISK I/O問題

Hostname=`cat /etc/zabbix/zabbix_agentd.conf | grep Hostname= | grep -v "#"`
		var_ip=`netstat -antu | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -n | wc -l`
		var_list=`netstat -antu |grep -i LISTEN|wc -l`
		var_ESTABLISHED=`netstat -antu |grep -i ESTABLISHED|wc -l`
		var_SYN_RECV=`netstat -antu |grep -i SYN_RECV|wc -l`
		var_SYN_SENT=`netstat -antu |grep -i SYN_SENT|wc -l`
		var_TIME_WAIT=`netstat -antu |grep -i TIME_WAIT|wc -l`
		var_CLOSE_WAIT=`netstat -antu |grep -i CLOSE_WAIT|wc -l`
		var_FIN_WAIT1=`netstat -antu |grep -i FIN_WAIT1|wc -l`
		var_FIN_WAIT2=`netstat -antu |grep -i FIN_WAIT2|wc -l`
		var_CLOSING=`netstat -antu |grep -i CLOSING|wc -l`
		var_Foreign=`netstat -antu |grep -i Foreign|wc -l`
		var_LAST_ACK=`netstat -antu |grep -i LAST_ACK|wc -l`
echo "Type=access,$Hostname,connections=$var_ip,LISTEN=$var_list,ESTABLISHED=$var_ESTABLISHED,SYN_RECV=$var_SYN_RECV,SYN_SENT=$var_SYN_SENT,LAST_ACK=$var_LAST_ACK,TIME_WAIT=$var_TIME_WAIT,CLOSE_WAIT=$var_CLOSE_WAIT,FIN_WAIT1=$var_FIN_WAIT1,FIN_WAIT2=$var_FIN_WAIT2,CLOSING=$var_CLOSING,Foreign=$var_Foreign" | nc 61.216.144.184 -u 514 -w 1
