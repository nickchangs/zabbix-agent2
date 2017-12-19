#!/bin/bash
 
HOST="localhost"
#PORT="80"
 
# 检测nginx进程是否存在
function ping {
    /usr/bin/ps -ef | grep -v grep | grep -i nginx | wc -l
}
#check 110 failed connection time out log counter
function failed {
date=`date -d "1 minutes ago" | awk '{print $4}' | cut -d: -f1,2`
cat /opt/logs/nginx/*.error.log | grep `date -d '1 minute ago' '+%H:%M'` | grep "failed" | wc -l
}
 检测nginx性能
function active {
    /usr/bin/curl "http://$HOST/nginx_status/" 2>/dev/null| grep 'Active' | awk '{print $NF}'
}
function reading {
    /usr/bin/curl "http://$HOST/nginx_status/" 2>/dev/null| grep 'Reading' | awk '{print $2}'
}
function writing {
    /usr/bin/curl "http://$HOST/nginx_status/" 2>/dev/null| grep 'Writing' | awk '{print $4}'
}
function waiting {
    /usr/bin/curl "http://$HOST/nginx_status/" 2>/dev/null| grep 'Waiting' | awk '{print $6}'
}
function accepts {
    /usr/bin/curl "http://$HOST/nginx_status/" 2>/dev/null| awk NR==3 | awk '{print $1}'
}
function handled {
    /usr/bin/curl "http://$HOST/nginx_status/" 2>/dev/null| awk NR==3 | awk '{print $2}'
}
function requests {
    /usr/bin/curl "http://$HOST/nginx_status/" 2>/dev/null| awk NR==3 | awk '{print $3}'
}

#check 110 failed connection time out log counter

$1
