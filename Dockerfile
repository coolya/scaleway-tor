## -*- docker-image-name: "armbuild/scw-app-kolab:latest" -*-
FROM scaleway/debian:amd64-jessie
# following 'FROM' lines are used dynamically thanks do the image-builder
# which dynamically update the Dockerfile if needed.
#FROM scaleway/debian:armhf-jessie	# arch=armv7l
#FROM scaleway/debian:arm64-jessie	# arch=arm64
#FROM scaleway/debian:i386-jessie		# arch=i386
#FROM scaleway/debian:mips-jessie		# arch=mips

# Prepare rootfs for image-builder
RUN /usr/local/sbin/builder-enter

ADD ./patches/ /

RUN echo "deb http://deb.torproject.org/torproject.org jessie main" > /etc/apt/sources.list.d/tor.list
RUN echo "deb-src http://deb.torproject.org/torproject.org jessie main" >> /etc/apt/sources.list.d/tor.list


RUN  gpg --keyserver keys.gnupg.net --recv 886DDD89 && \
	gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | sudo apt-key add -

# Install packages
RUN apt-get -q update                   \
 && apt-get --force-yes -y -qq upgrade
 RUN  apt-get --force-yes install -y -q   \
	tor

RUN systemctl enable setup-tor.service
# Clean rootfs from image-builder

RUN /usr/local/sbin/builder-leave
