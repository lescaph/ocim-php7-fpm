FROM debian
MAINTAINER Antoine Marchand <antoine@svilupo.fr>

ENV DEBIAN_FRONTEND noninteractive

# Install utils
RUN \
  apt-get update && \
  apt-get -y install wget curl apt-utils

# Configure Dotdeb sources
RUN \
  wget -O - http://www.dotdeb.org/dotdeb.gpg | apt-key add - && \
  echo "deb http://packages.dotdeb.org jessie all" > /etc/apt/sources.list.d/dotdeb.list && \
  echo "\ndeb-src http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list.d/dotdeb.list && \
  apt-get update

RUN apt-get install -y php7.0-fpm php7.0 php7.0-mysql php7.0-imap php7.0-gd wkhtmltopdf

RUN mkdir "/run/php"

RUN sed -i -e "s/;daemonize = yes/daemonize = no/g" /etc/php/7.0/fpm/php-fpm.conf && \
    sed -i "s/listen = \/run\/php\/php7.0-fpm.sock/listen = 0.0.0.0:9001/g" /etc/php/7.0/fpm/pool.d/www.conf && \
    sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/"                  /etc/php/7.0/fpm/php.ini && \
    sed -i "s/;date.timezone =.*/date.timezone = Europe\/Paris/"        /etc/php/7.0/fpm/php.ini 

EXPOSE 9001

CMD ["php-fpm7.0", "-F"]
