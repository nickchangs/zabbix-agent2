#!/bin/bash

Envir=`cat /etc/zabbix/zabbix_agentd.conf | grep Hostname= | grep -v "#" | awk 'BEGIN {FS="_"}{print $2}'`

if [ "$1" == "3xx" ] ; then
	SC="3[0-9][0-9]"
elif [ "$1" == "4xx" ] ; then
	SC="4[0-9][0-9]"
elif [ "$1" == "5xx" ] ; then
	SC="5[0-9][0-9]"
else
	SC="$1"
fi

StatusCode=$SC
PortNU=$2

function APP_Status() {
	cat /opt/logs/nginx/*-$PortNU.access.log | grep `date -d '1 minute ago' '+%d/%b/%Y:%H:%M'` | grep " status=$StatusCode" | wc -l
}

function BE_Status() {
        cat /opt/logs/nginx/*-https.access.log | grep `date -d '1 minute ago' '+%d/%b/%Y:%H:%M'` | grep " status=$StatusCode" | wc -l
}

function FE_Status() {
        cat /opt/logs/nginx/*.access.log | grep `date -d '1 minute ago' '+%d/%b/%Y:%H:%M'` | grep " status=$StatusCode" | wc -l
}

function PAY_Status() {
        cat /opt/logs/nginx/*.access.log | grep `date -d '1 minute ago' '+%d/%b/%Y:%H:%M'` | grep " status=$StatusCode" | wc -l
}
$Envir"_Status"
