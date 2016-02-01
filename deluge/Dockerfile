FROM alpine
MAINTAINER Rémi Alvergnat <toilal.dev@gmail.com>

# Add boost dependencies
RUN apk add --update build-base boost linux-headers bzip2-dev python python-dev &&\
    rm -rf /var/cache/apk/*

# Build boost
RUN wget http://downloads.sourceforge.net/project/boost/boost/1.60.0/boost_1_60_0.tar.gz &&\
    mkdir -p /usr/src &&\
    tar -zxf boost_1_60_0.tar.gz -C /usr/src &&\
    ln -s /usr/src/boost_1_60_0 /usr/src/boost &&\
    rm boost_1_60_0.tar.gz && \
    cd /usr/src/boost &&\
    bjam -d 0 release &&\
    bjam -d 0 --includedir=/usr/include --libdir=/usr/lib install &&\
    ln -s /usr/bin/bjam /usr/local/bin/b2

ENV BOOST_ROOT /usr/src/boost
ENV BOOST_BUILD_PATH /usr/src/boost/tools/build

# Add libtorrent dependencies
RUN apk add --update openssl openssl-dev &&\
   rm -rf /var/cache/apk/*

# build libtorrent
RUN wget https://github.com/arvidn/libtorrent/archive/libtorrent-1_0_8.tar.gz &&\
    mkdir -p /usr/src &&\
    tar -zxf libtorrent-1_0_8.tar.gz -C /usr/src &&\
    ln -s /usr/src/libtorrent-libtorrent-1_0_8 /usr/src/libtorrent &&\
    rm libtorrent-1_0_8.tar.gz &&\
    cd /usr/src/libtorrent &&\
    bjam -d 0 release encryption=openssl

# build libtorrent python bindings
RUN cd /usr/src/libtorrent/bindings/python && python setup.py install

# install deluge alpine dependencies
RUN apk add --update libffi-dev geoip-dev intltool py-pip py-cffi py-gtk xdg-utils &&\
    rm -rf /var/cache/apk/*

# install deluge pip dependencies
RUN pip install setuptools six pyopenssl twisted[tls] chardet mako pyxdg slimit service_identity

# clone and install deluge
RUN apk add --update git &&\
 git clone -b develop https://github.com/deluge-torrent/deluge.git /opt/deluge &&\
 cd /opt/deluge && \
 python setup.py build_plugins &&\
 # setup.py install doesn't work properly with deluge 2.0, fallback to develop mode.
 python setup.py develop &&\
 apk del git &&\
 rm -rf /var/cache/apk/*

# install s6 overlay
RUN wget https://github.com/just-containers/s6-overlay/releases/download/v1.17.1.2/s6-overlay-amd64.tar.gz -O /tmp/s6-overlay.tar.gz &&\
 tar xzf /tmp/s6-overlay.tar.gz -C / &&\
 rm /tmp/s6-overlay.tar.gz

RUN adduser -u 1337 -S box -H

ADD services.d /etc/services.d/
ADD fix-attrs.d /etc/fix-attrs.d/

RUN mkdir -p /var/deluge/config
RUN mkdir -p /var/deluge/downloads

COPY config/* /var/deluge/config/

EXPOSE 8112
EXPOSE 58846

WORKDIR /var/deluge
VOLUME /var/deluge

ENTRYPOINT ["/init"]