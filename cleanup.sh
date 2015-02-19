#!/bin/bash

# Clean up our source for tivodecode
rm -rf /opt/tivodecode*

# Clean up APT when done.
apt-get -y remove build-essential
apt-get -y autoremove 
apt-get clean 
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
