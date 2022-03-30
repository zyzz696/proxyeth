#!/bin/bash

PROCESS="python";
if ps ax | grep -v grep | grep $PROCESS > /dev/null
then
        echo "$PROCESS is running" ;
else
        echo "$PROCESS is NOT running" ;		
		ps -ef | grep 'python' | grep -v grep | awk '{print $2}' | xargs -r kill -9
#		sudo su -
		cd /root/eth-proxy/ && nohup ./run-proxy.sh > run.log 2>&1 &

fi
