FROM alpine:3.10

ARG DEPLOY_KEY

RUN apk add --no-cache --update alpine-sdk bash libpng-dev lcms2-dev g++ make zlib-dev \
  openssl-dev git nodejs nodejs-npm yarn icu-dev openssh-client imap-dev supervisor tzdata \
  docker gnu-libiconv mysql-client

RUN apk add --no-cache php7 php7-common php7-xmlrpc php7-xmlwriter php7-xsl php7-zip \
  php7-recode php7-session php7-shmop php7-simplexml php7-snmp php7-soap php7-sockets \
  php7-sockets php7-sqlite3 php7-sysvmsg php7-sysvsem php7-sysvshm php7-tidy php7-tokenizer \
  php7-wddx php7-xml php7-xmlreader php7-mysqlnd php7-odbc php7-opcache php7-openssl \
  php7-pcntl php7-pdo php7-pdo_mysql php7-pdo_sqlite php7-phar php7-posix php7-pspell php7-enchant \
  php7-exif php7-fileinfo php7-ftp php7-gd php7-gettext php7-gmp php7-iconv php7-imap \
  php7-intl php7-json php7-ldap php7-mbstring php7-mcrypt php7-mysqli php7-apache2 \
  php7-bcmath php7-bz2 php7-calendar php7-cgi php7-ctype php7-curl php7-dba php7-dom \
  php7-embed php7-fpm php7-litespeed php7-pear php7-phpdbg php7-dev php7-doc php7-apcu \
  php7-memcached php7-pecl-imagick php7-pecl-imagick-dev php7-xdebug php7-amqp php7-mailparse \
  php7-oauth php7-pear-mail_mime php7-redis php7-zmq

RUN npm install -g pngquant-bin --unsafe-perm --allow-root &&\
  cp /usr/share/zoneinfo/Europe/Warsaw /etc/localtime

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN curl https://phar.phpunit.de/phpunit-8.2.3.phar -L > phpunit.phar \
  && chmod +x phpunit.phar \
  && mv phpunit.phar /usr/local/bin/phpunit \
  && phpunit --version

RUN mkdir /root/.ssh &&\
  echo "${DEPLOY_KEY}" > /root/.ssh/id_rsa &&\
  echo -e "Host *\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config &&\
  chmod 600 /root/.ssh -R

RUN echo "memory_limit = 512M" >> /etc/php7/conf.d/memory.ini &&\
  echo "date.timezone = Europe/Warsaw" >> /etc/php7/conf.d/timezone.ini

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php
