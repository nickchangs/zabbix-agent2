#!/bin/bash
#這個script是用來計算四個服務的access IP,可下參數M或m來查詢前一分鐘的資料;可下參數H或h來查詢前一小時的資料;沒有參數的話則是查詢一整天的資料

TimeRange=`date -d '1 minute ago' '+%d/%b/%Y:%H:%M'`

Envir=`cat /etc/zabbix/zabbix_agentd.conf | grep Hostname= | grep -v "#" | awk 'BEGIN {FS="_"}{print $2}'`
Hostname=`cat /etc/zabbix/zabbix_agentd.conf | grep Hostname= | grep -v "#"`

function APP_AccessIP() {
Total=`ls /opt/logs/nginx/*.access.log | wc -l`

        for (( i=1 ; i<=$Total ; i=i+1 ))
        do
                LogFile=`ls /opt/logs/nginx/*.access.log | head -n $i | tail -n 1`
                cat $LogFile | grep $TimeRange | awk '{print $3}' > /tmp/AccessIPList
        done
var_ip=`cat /tmp/AccessIPList | sort | uniq -c | sort -n | wc -l`
echo "Type=access,$Hostname,connections=$var_ip" | nc 61.216.144.184 -u 514 -w 1
#rm -rf /tmp/AccessIPList
}

function be_AccessIP()  {
        var_ip=`cat /opt/logs/nginx/*-https.access.log | grep $TimeRange | awk '{print $3}' | sort | uniq -c | sort -n | wc -l`
        echo "Type=access,$Hostname,connections=$var_ip" | nc 61.216.144.184 -u 514 -w 1
}

function fd_AccessIP()  {
        var_ip=`cat /opt/logs/nginx/*.access.log | grep $TimeRange | awk '{print $3}' | sort | uniq -c | sort -n | wc -l`
        echo "Type=access,$Hostname,connections=$var_ip" | nc 61.216.144.184 -u 514 -w 1
}

function py_AccessIP()  {
        var_ip=`cat /opt/logs/nginx/*.access.log | grep $TimeRange | awk '{print $3}' | sort | uniq -c | sort -n | wc -l`
        var_list=`netstat -ant |grep -i LISTEN|wc -l`
        var_ESTABLISHED=`netstat -ant |grep -i ESTABLISHED|wc -l`
        var_SYN_RECV=`netstat -ant |grep -i SYN_RECV|wc -l`
        var_SYN_SENT=`netstat -ant |grep -i SYN_SENT|wc -l`
        var_TIME_WAIT=`netstat -ant |grep -i TIME_WAIT|wc -l`
        echo "Type=access,$Hostname,connections=$var_ip,LISTEN=$var_list,ESTABLISHED=$var_ESTABLISHED,SYN_RECV=$var_SYN_RECV,SYN_SENT=$var_SYN_SENT,TIME_WAIT=$var_TIME_WAIT" | nc 61.216.144.184 -u 514 -w 1
}
$Envir"_AccessIP"
