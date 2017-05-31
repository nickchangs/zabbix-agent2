#!/bin/bash

FileName=/var/log/ip_connection/`date +'%Y-%m-%d'`.connection.log
date +'%Y/%m/%d-%H:%M:%S' >> $FileName
echo "" >> $FileName
netstat -ntu | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -n | grep -v 127.0.0.1 | tail -n 30 >> $FileName
echo "" >> $FileName