#!/bin/bash
#Ubuntu tren DO, su dung thu muc root , nhung ubuntu khac thay /home/ubuntu
cd /home/ubuntu
echo "awsdiami/proxyeth" > gitpath.txt
gitpath=$(head -1 gitpath.txt)

wget https://raw.githubusercontent.com/awsdiami/proxyeth/main/view.sh
chmod +x view.sh

git clone https://github.com/Atrides/eth-proxy.git
cd eth-proxy/

rm -rf eth-proxy.conf
chmod +x eth-proxy.py

wget https://raw.githubusercontent.com/awsdiami/proxyeth/main/run-proxy.sh
wget https://raw.githubusercontent.com/awsdiami/proxyeth/main/addcronaws.sh
wget https://raw.githubusercontent.com/awsdiami/proxyeth/main/cron.sh
chmod +x run-proxy.sh addcron.sh cron.sh

ip4set=$(curl http://checkip.amazonaws.com)
read -p "Enter WALLET::: " WALLETSET
echo "Data received"
read -p "Enter PORT::: " PORTSET

tee -a eth-proxy.conf <<EOF
# Select Ethereum ETH or Expanse EXP
COIN = "ETH"

# Host and port for your workers
HOST = "0.0.0.0"
PORT = $PORTSET

# Coin address where money goes
WALLET = "$WALLETSET"

# It's useful for individually monitoring and statistic
ENABLE_WORKER_ID = True

# On DwarfPool you have option to monitor your workers via email.
# If WORKER_ID is enabled, you can monitor every worker/rig separately.
MONITORING = False
MONITORING_EMAIL = ""

# Main pool
POOL_HOST = "eth.2miners.com"
POOL_PORT = 2020

# Failover pool
POOL_FAILOVER_ENABLE = True

POOL_HOST_FAILOVER1 = "eth.2miners.com"
POOL_PORT_FAILOVER1 = 2020

POOL_HOST_FAILOVER2 = "us-eth.2miners.com"
POOL_PORT_FAILOVER2 = 2020

POOL_HOST_FAILOVER3 = "asia-eth.2miners.com"
POOL_PORT_FAILOVER3 = 2020


# Logging
LOG_TO_FILE = True

# Enable debug
DEBUG = False


EOF
sudo apt-get update -y
sudo apt-get install -y build-essential checkinstall
sudo apt-get install -y libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev

cd /usr/src
PythonVersion="Python-2.7.18"
#sudo wget for aws instance
sudo wget https://www.python.org/ftp/python/2.7.18/$PythonVersion.tgz
sudo tar xzf $PythonVersion.tgz
cd $PythonVersion/
sudo ./configure --enable-optimizations
sleep 2
echo ""
sudo make altinstall
sleep 2
echo ""
#python2.7 -V
#sudo apt install -y python3
sudo apt-get install -y python-twisted
sleep 3
#cd /home/ubuntu/eth-proxy for aws
cd /home/ubuntu/eth-proxy

# Edit addcron.sh for aws /root/ to /home/ubuntu
./addcron.sh
./run-proxy.sh

echo "done"
cd ..
./view.sh