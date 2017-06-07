/#!/bin/bash
#這個script是用來計算四個服務的access IP,可下參數M或m來查詢前一分鐘的資料;可下參數H或h來查詢前一小時的資料;沒有參數的話則是查詢一整天的資料

case ${1} in
  [Mm])
    TimeRange=`date -d '1 minute ago' '+%d/%b/%Y:%H:%M'`
    ;;
  [Hh])
    TimeRange=`date -d '1 hours ago' '+%d/%b/%Y:%H'`
    ;;
  *)
    TimeRange=`date '+%d/%b/%Y'`
    ;;
esac

Envir=`cat /etc/zabbix/zabbix_agentd.conf | grep Hostname= | grep -v "#" | awk 'BEGIN {FS="_"}{print $2}'`

function APP_AccessIP() {
Total=`ls /opt/logs/nginx/*.access.log | wc -l`

        for (( i=1 ; i<=$Total ; i=i+1 ))
        do
                LogFile=`ls /opt/logs/nginx/*.access.log | head -n $i | tail -n 1`
                cat $LogFile | grep $TimeRange | awk '{print $3}' >> /tmp/AccessIPList
        done
cat /tmp/AccessIPList | sort | uniq -c | sort -n | wc -l
rm -rf /tmp/AccessIPList
}

function be_AccessIP()  {
        cat /opt/logs/nginx/*-https.access.log | grep $TimeRange | awk '{print $3}' | sort | uniq -c | sort -n | wc -l
}

function fd_AccessIP()  {
        cat /opt/logs/nginx/*.access.log | grep $TimeRange | awk '{print $3}' | sort | uniq -c | sort -n | wc -l
}

function py_AccessIP()  {
        cat /opt/logs/nginx/*.access.log | grep $TimeRange | awk '{print $3}' | sort | uniq -c | sort -n | wc -l
}
$Envir"_AccessIP"
