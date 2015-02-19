#!/bin/bash

# Add FFMPEG PPA
add-apt-repository ppa:jon-severinsson/ffmpeg 

# Install what we can with apt
apt-get -q update && apt-get install -qy \
  build-essential \
  ffmpeg \
  python \
  wget

# Install the 2014-07-06 release of pyTivo to /opt/pytivo
wget http://repo.or.cz/w/pyTivo/wmcbrine/lucasnz.git/snapshot/2f1f223bd62e30a4774828a3c811b1194e18b703.tar.gz -O - | \
  tar -xzf - -C /opt/pytivo

# Create the init script for pytivo
cat <<EOD > /etc/my_init.d/pytivo.sh
#!/bin/bash

/sbin/setuser nobody cp -R -u -p /opt/pytivo/lucasnz/pyTivo.conf.dist /config/pyTivo.conf
exec /sbin/setuser nobody python /opt/pytivo/lucasnz/pyTivo.py -c /config/pyTivo.conf > /config/pyTivo.log 2>&1
EOD
chmod 755 /etc/my_init.d/pytivo.sh

# Compile tivodecode and tdcat, install to /usr/local/bin/ (pyTivo will be able to find this automatically)
wget http://sourceforge.net/projects/tivodecode/files/tivodecode/0.2pre4/tivodecode-0.2pre4.tar.gz -O - | \
  tar xfz - -C /opt/

cd /opt/tivodecode-0.2pre4
./configure 
make
make install

