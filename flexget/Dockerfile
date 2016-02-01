FROM alpine
MAINTAINER Rémi Alvergnat <toilal.dev@gmail.com>

RUN apk add --update python py-pip && rm -rf /var/cache/apk/*

RUN apk add --update git &&\
 git clone -b master https://github.com/Flexget/Flexget.git /opt/flexget &&\
 apk del git &&\
 rm -rf /var/cache/apk/*

WORKDIR /opt/flexget
RUN pip install paver
RUN pip install -e .

RUN mkdir -p /var/flexget/
ADD flexget/* /var/flexget/

RUN adduser -u 1337 -S box -H
RUN chown -R box /var/flexget && chown -R box /opt/flexget

WORKDIR /var/flexget/
VOLUME /var/flexget/

USER box
CMD ["flexget", "-c", "/var/flexget/config.yml"]
