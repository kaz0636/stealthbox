FROM alpine
MAINTAINER Rémi Alvergnat <toilal.dev@gmail.com>

RUN mkdir -p /opt
RUN wget -qO- http://sourceforge.net/projects/ajaxplorer/files/pydio/stable-channel/6.2.2/pydio-core-6.2.2.tar.gz \
    | tar xvz -C /opt
RUN ln -s /opt/pydio-core-6.2.2 /opt/pydio

ADD pydio/bootstrap.json /opt/pydio/data/plugins/boot.conf/
ADD pydio/pydio.db /opt/pydio/data/plugins/conf.sql/
ADD pydio/cache/* /opt/pydio/data/cache/

RUN chown -R nobody:nobody /opt/pydio-core-6.2.2

VOLUME /opt/pydio
WORKDIR /opt/pydio

CMD ["echo", "Pydio Data Container"]