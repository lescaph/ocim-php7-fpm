FROM debian:jessie
MAINTAINER Antoine Marchand <antoine@svilupo.fr>

ENV DEBIAN_FRONTEND noninteractive

WORKDIR /tmp

# Install utils
RUN \
  apt-get update && \
  apt-get -y install wget curl apt-utils ssmtp xz-utils libxrender-dev git && \

# Configure git
  git config --global url."https://".insteadOf git:// && \

# Configure Dotdeb sources
  wget -O - http://www.dotdeb.org/dotdeb.gpg | apt-key add - && \
  echo "deb http://packages.dotdeb.org jessie all" > /etc/apt/sources.list.d/dotdeb.list && \
  echo "\ndeb-src http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list.d/dotdeb.list && \
  apt-get update && \
  apt-get install -y php7.0-fpm php7.0 php7.0-mysql php7.0-pgsql php7.0-curl php7.0-mcrypt php7.0-intl php7.0-bz2 php7.0-imap php7.0-gd php7.0-json && \

# INSTALL NODEJS NPM BOWER GULP
    curl -sL https://deb.nodesource.com/setup_5.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm && \
    npm install -g bower && \
    npm install -g gulp && \

# INSTALL WKHTMLTOPDF
    wget http://download.gna.org/wkhtmltopdf/0.12/0.12.3/wkhtmltox-0.12.3_linux-generic-amd64.tar.xz && \
    tar xf wkhtmltox-0.12.3_linux-generic-amd64.tar.xz && \
    cp wkhtmltox/bin/wkhtmltopdf /usr/local/bin/ && \

# INSTALL COMPOSER
    php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
    php -r "unlink('composer-setup.php');"  && \

# CONFIGURE PHP
    mkdir "/run/php" && \

    sed -i -e "s/;daemonize = yes/daemonize = no/g" /etc/php/7.0/fpm/php-fpm.conf && \
    sed -i "s/listen = \/run\/php\/php7.0-fpm.sock/listen = 0.0.0.0:9001/g" /etc/php/7.0/fpm/pool.d/www.conf && \
    sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/"                  /etc/php/7.0/fpm/php.ini && \
    sed -i "s/;date.timezone =.*/date.timezone = Europe\/Paris/"        /etc/php/7.0/fpm/php.ini

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 9001

CMD ["php-fpm7.0", "-F"]
