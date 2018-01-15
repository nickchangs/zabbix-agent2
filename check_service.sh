#!/bin/sh
service="$1"
status=`/bin/systemctl status $service.service`
if echo "$status" |grep -q running; then 
echo "Status 0 - OK : $service is running"
else
if echo "$status" | grep -q stopped; then
echo "Status 1 - Critical : $service is not running"
else
echo "Status 2 - Information : $service is unrecognized service"
fi
fi
