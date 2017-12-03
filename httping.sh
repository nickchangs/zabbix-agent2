#!/bin/bash  
metric=$1  
host=$2  
port=$3  
proto=$4  
tmp_file=/tmp/${metric}_httping_status.txt  
if [ $proto == "https" ];then  
/bin/httping -c5 -t3 -l $url > $tmp_file 
#/bin/httping -c5 -t3 -l $proto://$host:$port > $tmp_file  
    case $metric in  
        status)  
        output=$(cat $tmp_file |grep connected |wc -l )  
        if [ $output -eq 3 ];then  
         output=1  
        echo $output  
        else  
             output=0  
        echo $output  
        fi  
        ;;  
        failed)  
            output=$(cat $tmp_file |grep failed|awk '{print $5}'|awk -F'%' '{print $1}' )  
            if [ "$output" == "" ];then  
             echo 100  
          else  
             echo $output  
          fi  
            ;;  
        min)  
          output=$( cat $tmp_file|grep min|awk '{print $4}'|awk -F/ '{print $1}' )  
          if [ "$output" == "" ];then  
             echo 0  
          else  
             echo $output  
          fi  
        ;;  
        avg)  
            output=$(cat $tmp_file|grep avg|awk '{print $4}'|awk -F/ '{print $2}')  
          if [ "$output" == "" ];then  
             echo 0  
          else  
             echo $output  
          fi  
            ;;  
        max)  
                output=$(cat $tmp_file|grep max|awk '{print $4}'|awk -F/ '{print $3}')  
          if [ "$output" == "" ];then  
            echo 0  
          else  
             echo $output  
          fi  
            ;;
	loss)
		output=$(cat $tmp_file|grep ok|awk '{print $5}' |awk -F% '{print $1}')
          if [ "$output" == "" ];then
            echo 0  
          else
             echo $output  
          fi
            ;;  
        *)  
        echo -e "\e[033mUsage: sh  $0 [status|failed|min|avg|max]\e[0m"  
       esac  
elif [ $proto == "http" ];then  
    /bin/httping -c5 -t3 $proto://$host:$port > $tmp_file  
    case $metric in  
            status)  
        output=$(cat $tmp_file |grep connected |wc -l )  
        if [ $output -eq 3 ];then  
           output=1  
        echo $output  
        else  
         output=0  
         echo   $output  
        fi  
        ;;  
        failed)  
            output=$(cat $tmp_file |grep failed|awk '{print $5}'|awk -F'%' '{print $1}' )  
            if [ "$output" == "" ];then  
             echo 100  
          else  
             echo $output  
          fi  
            ;;  
        min)  
          output=$( cat $tmp_file|grep min|awk '{print $4}'|awk -F/ '{print $1}' )  
          if [ "$output" == "" ];then  
             echo 0  
          else  
             echo $output  
          fi  
        ;;  
        avg)  
            output=$(cat $tmp_file|grep avg|awk '{print $4}'|awk -F/ '{print $2}')  
          if [ "$output" == "" ];then  
             echo 0  
          else  
             echo $output  
          fi  
            ;;  
        max)  
                output=$(cat $tmp_file|grep max|awk '{print $4}'|awk -F/ '{print $3}')  
          if [ "$output" == "" ];then  
             echo 0  
          else  
             echo $output  
          fi  
            ;;  
        loss)
                output=$(cat $tmp_file|grep ok|awk '{print $5}' |awk -F% '{print $1}') 
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
    echo "error parm " $proto >/tmp/httping_error.log  
 fi 
