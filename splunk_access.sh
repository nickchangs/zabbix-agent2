#!/bin/bash
#這個script是用來計算四個服務的access IP和netstat的狀態，並丟到SPLUNK分析
#此程式服務器必需安裝NC及net-tools，HOSTNAME是抓zabbix-agent.conf裡面的資訊
#AccessIPList寫到/TMP/裡後，只有APP會加總進行統計後抓出CLIENT IP數量
#先將各NETSTAT抓一次到/TMP/裡面，再用語法抓出來各資訊
#請確認目前log file的大小，一定要logrotate有在執行，只存1天的LOG，其他是被壓縮起來的，不會會造成DISK I/O問題

TimeRange=`date -d '1 minute ago' '+%d/%b/%Y:%H:%M'`

Envir=`cat /etc/zabbix/zabbix_agentd.conf | grep Hostname= | grep -v "#" | awk 'BEGIN {FS="_"}{print $2}'`
Hostname=`cat /etc/zabbix/zabbix_agentd.conf | grep Hostname= | grep -v "#"`
netstat_log=`netstat -nat |awk '{print $6}'|sort|uniq -c|sort -rn > /tmp/netstatlog`

function APP_AccessIP() {
Total=`ls /opt/logs/nginx/*.access.log | wc -l`

        for (( i=1 ; i<=$Total ; i=i+1 ))
        do
                LogFile=`ls /opt/logs/nginx/*.access.log | head -n $i | tail -n 1`
                cat $LogFile | grep $TimeRange | awk '{print $3}' >> /tmp/AccessIPList
        done
var_ip=`cat /tmp/AccessIPList | sort | uniq -c | sort -n | wc -l`
var_list=`cat $netstat_log |grep -i LISTEN| awk {'print $1'}`
var_ESTABLISHED=`cat $netstat_log |grep -i ESTABLISHED| awk {'print $1'}`
var_SYN_RECV=`cat $netstat_log |grep -i SYN_RECV| awk {'print $1'}`
var_SYN_SENT=`cat $netstat_log |grep -i SYN_SENT| awk {'print $1'}`
var_TIME_WAIT=`cat $netstat_log |grep -i TIME_WAIT| awk {'print $1'}`
var_CLOSE_WAIT=`cat $netstat_log |grep -i CLOSE_WAIT| awk {'print $1'}`
var_FIN_WAIT1=`cat $netstat_log |grep -i FIN_WAIT1| awk {'print $1'}`
var_FIN_WAIT2=`cat $netstat_log |grep -i FIN_WAIT2| awk {'print $1'}`
var_CLOSING=`cat $netstat_log |grep -i CLOSING| awk {'print $1'}`
var_Foreign=`cat $netstat_log |grep -i Foreign| awk {'print $1'}`
echo "Type=access,$Hostname,connections=$var_ip,LISTEN=$var_list,ESTABLISHED=$var_ESTABLISHED,SYN_RECV=$var_SYN_RECV,SYN_SENT=$var_SYN_SENT,TIME_WAIT=$var_TIME_WAIT",CLOSE_WAIT=$var_CLOSE_WAIT",FIN_WAIT1=$var_FIN_WAIT1,FIN_WAIT2=$var_FIN_WAIT2",CLOSING=$var_CLOSING,Foreign=$var_Foreign" | nc 61.216.144.184 -u 514 -w 1
rm -rf /tmp/AccessIPList
}

function BE_AccessIP()  {
        var_ip=`cat /opt/logs/nginx/*-https.access.log | grep $TimeRange | awk '{print $3}' | sort | uniq -c | sort -n | wc -l`
        var_list=`cat $netstat_log |grep -i LISTEN| awk {'print $1'}`
        var_ESTABLISHED=`cat $netstat_log |grep -i ESTABLISHED| awk {'print $1'}`
        var_SYN_RECV=`cat $netstat_log |grep -i SYN_RECV| awk {'print $1'}`
        var_SYN_SENT=`cat $netstat_log |grep -i SYN_SENT| awk {'print $1'}`
        var_TIME_WAIT=`cat $netstat_log |grep -i TIME_WAIT| awk {'print $1'}`
        var_CLOSE_WAIT=`cat $netstat_log |grep -i CLOSE_WAIT| awk {'print $1'}`
        var_FIN_WAIT1=`cat $netstat_log |grep -i FIN_WAIT1| awk {'print $1'}`
        var_FIN_WAIT2=`cat $netstat_log |grep -i FIN_WAIT2| awk {'print $1'}`
        var_CLOSING=`cat $netstat_log |grep -i CLOSING| awk {'print $1'}`
        var_Foreign=`cat $netstat_log |grep -i Foreign| awk {'print $1'}`
        echo "Type=access,$Hostname,connections=$var_ip,LISTEN=$var_list,ESTABLISHED=$var_ESTABLISHED,SYN_RECV=$var_SYN_RECV,SYN_SENT=$var_SYN_SENT,TIME_WAIT=$var_TIME_WAIT",CLOSE_WAIT=$var_CLOSE_WAIT",FIN_WAIT1=$var_FIN_WAIT1,FIN_WAIT2=$var_FIN_WAIT2",CLOSING=$var_CLOSING,Foreign=$var_Foreign" | nc 61.216.144.184 -u 514 -w 1
        }

function FE_AccessIP()  {
        var_ip=`cat /opt/logs/nginx/*.access.log | grep $TimeRange | awk '{print $3}' | sort | uniq -c | sort -n | wc -l`
        var_list=`cat $netstat_log |grep -i LISTEN| awk {'print $1'}`
        var_ESTABLISHED=`cat $netstat_log |grep -i ESTABLISHED| awk {'print $1'}`
        var_SYN_RECV=`cat $netstat_log |grep -i SYN_RECV| awk {'print $1'}`
        var_SYN_SENT=`cat $netstat_log |grep -i SYN_SENT| awk {'print $1'}`
        var_TIME_WAIT=`cat $netstat_log |grep -i TIME_WAIT| awk {'print $1'}`
        var_CLOSE_WAIT=`cat $netstat_log |grep -i CLOSE_WAIT| awk {'print $1'}`
        var_FIN_WAIT1=`cat $netstat_log |grep -i FIN_WAIT1| awk {'print $1'}`
        var_FIN_WAIT2=`cat $netstat_log |grep -i FIN_WAIT2| awk {'print $1'}`
        var_CLOSING=`cat $netstat_log |grep -i CLOSING| awk {'print $1'}`
        var_Foreign=`cat $netstat_log |grep -i Foreign| awk {'print $1'}`
        echo "Type=access,$Hostname,connections=$var_ip,LISTEN=$var_list,ESTABLISHED=$var_ESTABLISHED,SYN_RECV=$var_SYN_RECV,SYN_SENT=$var_SYN_SENT,TIME_WAIT=$var_TIME_WAIT",CLOSE_WAIT=$var_CLOSE_WAIT",FIN_WAIT1=$var_FIN_WAIT1,FIN_WAIT2=$var_FIN_WAIT2",CLOSING=$var_CLOSING,Foreign=$var_Foreign" | nc 61.216.144.184 -u 514 -w 1
        }

function PAY_AccessIP()  {
        var_ip=`cat /opt/logs/nginx/*.access.log | grep $TimeRange | awk '{print $3}' | sort | uniq -c | sort -n | wc -l`
        var_list=`cat $netstat_log |grep -i LISTEN| awk {'print $1'}`
        var_ESTABLISHED=`cat $netstat_log |grep -i ESTABLISHED| awk {'print $1'}`
        var_SYN_RECV=`cat $netstat_log |grep -i SYN_RECV| awk {'print $1'}`
        var_SYN_SENT=`cat $netstat_log |grep -i SYN_SENT| awk {'print $1'}`
        var_TIME_WAIT=`cat $netstat_log |grep -i TIME_WAIT| awk {'print $1'}`
        var_CLOSE_WAIT=`cat $netstat_log |grep -i CLOSE_WAIT| awk {'print $1'}`
        var_FIN_WAIT1=`cat $netstat_log |grep -i FIN_WAIT1| awk {'print $1'}`
        var_FIN_WAIT2=`cat $netstat_log |grep -i FIN_WAIT2| awk {'print $1'}`
        var_CLOSING=`cat $netstat_log |grep -i CLOSING| awk {'print $1'}`
        var_Foreign=`cat $netstat_log |grep -i Foreign| awk {'print $1'}`
        echo "Type=access,$Hostname,connections=$var_ip,LISTEN=$var_list,ESTABLISHED=$var_ESTABLISHED,SYN_RECV=$var_SYN_RECV,SYN_SENT=$var_SYN_SENT,TIME_WAIT=$var_TIME_WAIT",CLOSE_WAIT=$var_CLOSE_WAIT",FIN_WAIT1=$var_FIN_WAIT1,FIN_WAIT2=$var_FIN_WAIT2",CLOSING=$var_CLOSING,Foreign=$var_Foreign" | nc 61.216.144.184 -u 514 -w 1
        }
$Envir"_AccessIP"
