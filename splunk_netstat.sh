#!/bin/bash
Hostname=`cat /etc/zabbix/zabbix_agentd.conf | grep Hostname= | grep -v "#"`
var_list=`netstat -ant |grep -i LISTEN|wc -l`
var_ESTABLISHED=`netstat -ant |grep -i ESTABLISHED|wc -l`
var_SYN_RECV=`netstat -ant |grep -i SYN_RECV|wc -l`
var_SYN_SENT=`netstat -ant |grep -i SYN_SENT|wc -l`
var_TIME_WAIT=`netstat -ant |grep -i TIME_WAIT|wc -l`
echo "Type=netstats,$Hostname,LISTEN=$var_list,ESTABLISHED=$var_ESTABLISHED,SYN_RECV=$var_SYN_RECV,SYN_SENT=$var_SYN_SENT,TIME_WAIT=$var_TIME_WAIT" | nc 61.216.144.184 -u 514 -w 1
