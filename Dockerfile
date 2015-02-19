FROM phusion/baseimage:0.9.16
MAINTAINER Justin Ellison <justin@techadvise.com>

# Set correct environment variables.
ENV DEBIAN_FRONTEND noninteractive

# Set correct environment variables
ENV HOME /root

ADD . /build

RUN /build/prepare.sh && \
	/build/install.sh && \
	/build/cleanup.sh


# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

VOLUME /config
VOLUME /media

EXPOSE 2190
EXPOSE 9032

