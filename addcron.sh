#!/bin/bash
crontab -r

cron="* * * * * cd /root/eth-proxy && ./cron.sh"
(crontab -u root -l; echo "$cron" ) | crontab -u root -


#create default content run after reboot
tee -a atreboot.txt <<EOF
@reboot cd /root/eth-proxy && ./run-proxy.sh 2>&1 &
EOF

cronjobgen=$(cat atreboot.txt)
(crontab -u root -l; echo "$cronjobgen" ) | crontab -u root -

rm -rf atreboot.txt


# Clear log
tee -a clearlog.txt <<EOF
* 15 * * * cd /root/eth-proxy && echo > run.log >/dev/null 2>&1
EOF

clearlog=$(cat clearlog.txt)
(crontab -u root -l; echo "$clearlog" ) | crontab -u root -



