#!/bin/bash
crontab -r

cron="* * * * * cd /home/ubuntu/eth-proxy && ./cron.sh"
(crontab -u ubuntu -l; echo "$cron" ) | crontab -u ubuntu -


#create default content run after reboot
tee -a atreboot.txt <<EOF
@reboot cd /home/ubuntu/eth-proxy && ./run-proxy.sh 2>&1 &
EOF

cronjobgen=$(cat atreboot.txt)
(crontab -u ubuntu -l; echo "$cronjobgen" ) | crontab -u ubuntu -

rm -rf atreboot.txt


# Clear log
tee -a clearlog.txt <<EOF
* 15 * * * cd /home/ubuntu/eth-proxy && echo > run.log >/dev/null 2>&1
EOF

clearlog=$(cat clearlog.txt)
(crontab -u ubuntu -l; echo "$clearlog" ) | crontab -u ubuntu -

