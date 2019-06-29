#!/bin/bash
#Author:ZhangGe
#Desc:Auto Deny Black_IP Script.
#Date:2014-11-05
#Update:2019-04-16
#Update:2019-06-24 By ODM

#取得参数$1为最大值，若留空则默认允许单IP點擊量最大20
if [[ -z $1 ]]; then
  num=20
else
  num=$1
fi

#巧妙的进入到脚本工作目录
cd $(cd $(dirname $BASH_SOURCE) && pwd)

#目標字串
str="apis/login"
echo "目標字串 : "$str

create_name="black_"$(date '+%Y-%m-%d')
echo "ipset name: "$create_name

#創建ipset 集合與規則
#ipset create $create_name hash:ip
#iptables -I INPUT -m set --match-set $create_name src -j DROP

#请求检查、判断及拉黑主功能函数
function check() {
  # 時間區間
  check_time=$(date '+%Y:%H')

  # 抓取log 裡面uri ( apis/login ), 數量
  iplist=$(cat /opt/logs/nginx/*.access.log | grep "$str" | grep "$check_time" | awk '{print $3}' | awk -F\= '{print $2}' | sort | uniq -c | sort -rn | awk -v str=$num '{if ($1>str){print $2}}')
  echo "start $check_time"
  echo $iplist
  if [[ ! -z $iplist ]]; then
    >./black_ip.txt
    for black_ip in $iplist; do
      grep -q $black_ip ./white_ip.txt
      if [[ $? -eq 0 ]]; then
        echo "$black_ip (white_ip)" >>./black_ip.txt
      else
        echo $black_ip >>./black_ip.txt
        #iptables -nL | grep $black_ip || (
        #        iptables -I INPUT -s $black_ip -j DROP &
        #        echo "$black_ip  $(date +%Y-%m-%d/%H:%M:%S)" >>./deny.log
        #)
        ipset list deny_ip | grep $black_ip || (
          ipset add deny_ip $black_ip timeout 43200 &
          echo "$black_ip  $(date +%Y-%m-%d/%H:%M:%S)" >>./deny.log
        )
        sleep 1
      fi
    done
  fi
  echo "sleep"
}

#间隔30s无限循环检查函数
#while true; do
 check
#  #每隔30s检查一次，时间可根据需要自定义
#  sleep 30
#done
