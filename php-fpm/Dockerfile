FROM alpine
MAINTAINER Rémi Alvergnat <toilal.dev@gmail.com>

ENV PHP_MEMORY_LIMIT 512M
ENV MAX_UPLOAD 50M
ENV PHP_MAX_FILE_UPLOAD 200
ENV PHP_MAX_POST 100M

RUN apk add --update php-fpm php-json php-dom php-gd php-mcrypt php-exif php-iconv php-sqlite3 php-mysql php-pgsql \
                     php-openssl &&\
    rm -rf /var/cache/apk/*

RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/php-fpm.conf && \
    sed -i -e "s/listen\s*=\s*127.0.0.1:9000/listen = 9000/g" /etc/php/php-fpm.conf && \
    sed -i "s|memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|" /etc/php/php.ini && \
    sed -i "s|upload_max_filesize =.*|upload_max_filesize = ${MAX_UPLOAD}|" /etc/php/php.ini && \
    sed -i "s|max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|" /etc/php/php.ini && \
    sed -i "s|post_max_size =.*|post_max_size = ${PHP_MAX_POST}|" /etc/php/php.ini && \
    sed -i "s/output_buffering\s*=\s*\(.*\)/output_buffering = Off/g" /etc/php/php.ini && \
    sed -i "s/;session.save_path\s*=\s*\(.*\)/session.save_path =\1/g" /etc/php/php.ini && \
    sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/php.ini

EXPOSE 9000
ENTRYPOINT ["/usr/bin/php-fpm"]
