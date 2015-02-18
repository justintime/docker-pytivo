FROM phusion/baseimage:0.9.16
MAINTAINER Justin Ellison <justin@techadvise.com>

# Set correct environment variables.
ENV DEBIAN_FRONTEND noninteractive

# Set correct environment variables
ENV HOME /root

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Fix a Debianism of the nobody's uid being 65534
RUN usermod -u 99 nobody
RUN usermod -g 100 nobody

# Install ffmpeg to /usr/bin/ (pyTivo will be able to find this automatically)
RUN add-apt-repository ppa:jon-severinsson/ffmpeg && apt-get -q update && apt-get install -qy \
  build-essential \
  ffmpeg \
  python \
  wget

# Install the 2014-07-06 release of pyTivo
RUN mkdir /opt/pytivo && \
  wget http://repo.or.cz/w/pyTivo/wmcbrine/lucasnz.git/snapshot/2f1f223bd62e30a4774828a3c811b1194e18b703.tar.gz -O - | \
  tar -xzf - -C /opt/pytivo

# Compile tivodecode and tdcat, install to /usr/local/bin/ (pyTivo will be able to find this automatically)
RUN wget http://sourceforge.net/projects/tivodecode/files/tivodecode/0.2pre4/tivodecode-0.2pre4.tar.gz -O - | \
  tar xfz - -C /opt/
RUN cd /opt/tivodecode-0.2pre4; \
  ./configure && \
  make && \
  make install

VOLUME /config
VOLUME /media

EXPOSE 2190
EXPOSE 9032

# Add pytivo.sh to execute during container startup
RUN mkdir -p /etc/my_init.d
ADD pytivo.sh /etc/my_init.d/pytivo.sh
RUN chmod +x /etc/my_init.d/pytivo.sh

# Clean up APT when done.
RUN apt-get -y remove build-essential && \
  apt-get -y autoremove && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
