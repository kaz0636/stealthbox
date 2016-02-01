FROM alpine
MAINTAINER Rémi Alvergnat <toilal.dev@gmail.com>

RUN apk add --update python py-pip git && rm -rf /var/cache/apk/*

RUN mkdir -p /opt/sickrage
RUN git clone https://github.com/SickRage/SickRage.git /opt/sickrage
RUN pip install cheetah

RUN mkdir -p /var/sickrage
COPY sickrage/* /var/sickrage

RUN adduser -u 1337 -S box -H
RUN chown -R box /var/sickrage && chown -R box /opt/sickrage

WORKDIR /var/deluge
VOLUME /var/sickrage

EXPOSE 8074

USER box
CMD ["python", "/opt/sickrage/SickBeard.py", "--datadir=/var/sickrage", "--nolaunch"]
