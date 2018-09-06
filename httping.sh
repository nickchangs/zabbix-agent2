#!/bin/bash

metric=$1  
host=$2  
#port=$3  
proto=`echo $host | awk -F'://' '{print $1}'`
#tmp_file=/tmp/${metric}_httping_status.txt  

if [[ $proto == "https" ]];then  
#/bin/httping -c5 -t3 -l $proto://$host:$port > $tmp_file  
#echo $proto
    case $metric in  
        status)
        output=`/usr/bin/httping -f -c5 -t3 -l -I 1dkja93kj2 $host |grep connected |wc -l`
        #output=$(cat $tmp_file |grep connected |wc -l )
        if [ $output -eq 3 ];then  
         output=1  
        echo $output  
        else  
             output=0  
        echo $output  
        fi  
        ;;  
        failed)  
            output=`/usr/bin/httping -f -c5 -t3 -l -I 1dkja93kj2 $host |grep failed|awk '{print $5}'|awk -F'%' '{print $1}'`
            if [ "$output" == "" ];then  
             echo 100  
          else  
             echo $output  
          fi  
            ;;  
        min)  
          output=`/usr/bin/httping -f -c5 -t3 -l -I 1dkja93kj2 $host |grep min|awk '{print $4}'|awk -F/ '{print $1}'`
          if [ "$output" == "" ];then  
             echo 0  
          else  
             echo $output  
          fi  
        ;;  
        avg)  
            output=`/usr/bin/httping -f -c5 -t3 -l -I 1dkja93kj2 $host |grep avg|awk '{print $4}'|awk -F/ '{print $2}'`
          if [ "$output" == "" ];then  
             echo 0  
          else  
             echo $output  
          fi  
            ;;  
        max)  
                output=`/usr/bin/httping -f -c5 -t3 -l -I 1dkja93kj2 $host |grep max|awk '{print $4}'|awk -F/ '{print $3}'`
          if [[ "$output" == "" ]];then  
            echo 0  
          else  
             echo $output  
          fi  
            ;;
	loss)
		output=`/usr/bin/httping -f -c5 -t3 -l -I 1dkja93kj2 $host |grep ok|awk '{print $5}' |awk -F% '{print $1}'`
          if [ "$output" == "" ];then
            echo 0  
          else
             echo $output  
          fi
            ;;  
        *)  
        echo -e "\e[033mUsage: sh  $0 [status|failed|min|avg|max]\e[0m"  
       esac  
else
#echo $proto
    case $metric in
        status)
        output=`/usr/bin/httping -f -c5 -t3 -I 1dkja93kj2 $host |grep connected |wc -l`
        #output=$(cat $tmp_file |grep connected |wc -l )
        if [ $output -eq 3 ];then
         output=1
        echo $output
        else
             output=0
        echo $output
        fi
        ;;
        failed)
            output=`/usr/bin/httping -f -c5 -t3 -I 1dkja93kj2 $host |grep failed|awk '{print $5}'|awk -F'%' '{print $1}'`
            if [ "$output" == "" ];then
             echo 100
          else
             echo $output
          fi
            ;;
        min)
          output=`/usr/bin/httping -f -c5 -t3 -I 1dkja93kj2 $host |grep min|awk '{print $4}'|awk -F/ '{print $1}'`
          if [ "$output" == "" ];then
             echo 0
          else
             echo $output
          fi
        ;;
        avg)
            output=`/usr/bin/httping -f -c5 -t3 -I 1dkja93kj2 $host |grep avg|awk '{print $4}'|awk -F/ '{print $2}'`
          if [ "$output" == "" ];then
             echo 0
          else
             echo $output
          fi
            ;;
        max)
                output=`/usr/bin/httping -f -c5 -t3 -I 1dkja93kj2 $host |grep max|awk '{print $4}'|awk -F/ '{print $3}'`
          if [[ "$output" == "" ]];then
            echo 0
          else
             echo $output
          fi
            ;;
        loss)
                output=`/usr/bin/httping -f -c5 -t3 -I 1dkja93kj2 $host |grep ok|awk '{print $5}' |awk -F% '{print $1}'`
          if [ "$output" == "" ];then
            echo 0
          else
             echo $output
          fi
            ;;
        *)
        echo -e "\e[033mUsage: sh  $0 [status|failed|min|avg|max]\e[0m"
       esac  
fi
