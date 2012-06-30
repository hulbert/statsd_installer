# Get directory of this script for later moves of 
# adjacent default config files
INSTALLER_DIR="$( cd "$( dirname "$0" )" && pwd )"

yum install -y gcc gcc-c++ zlib-devel make curl curl-devel openssl git
cd /tmp

# Install node.js 0.8.1 (stable)
git clone https://github.com/joyent/node.git
pushd node
git checkout v0.8.1
./configure && make && make install
popd 
rm -rf node

# Install npm
curl http://npmjs.org/install.sh | sh

# Install StatsD and Librato Metrics backend for it
cd /usr/local/
git clone https://github.com/etsy/statsd.git
cd statsd
npm install statsd-librato-backend


cd $INSTALLER_DIR

# Create statsd config file
mkdir /etc/statsd/
cp local.js /etc/statsd/local.js

# Create /etc/init.d script
cp statsd.sh /etc/init.d/statsd

chmod +x /etc/init.d/statsd

# Enable StatsD
chkconfig --add statsd
chkconfig statsd on
service statsd start
