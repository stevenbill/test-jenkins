FROM phpdockerio/php71-fpm:latest
# Fix debconf warnings upon build
ARG DEBIAN_FRONTEND=noninteractive

# Install selected extensions and other stuff
RUN apt-get update \
    && apt-get -y --no-install-recommends install  php7.1-mysql php7.1-pgsql php7.1-sqlite3 php7.1-bcmath php7.1-bz2 php7.1-dba php7.1-enchant php7.1-gd php-gearman php7.1-gmp php-igbinary php7.1-imap php-imagick php7.1-interbase php7.1-intl php7.1-ldap php-mongodb php-msgpack php7.1-odbc php7.1-phpdbg php7.1-pspell php-raphf php7.1-recode php7.1-snmp php7.1-soap php-ssh2 php7.1-sybase php7.1-tidy php7.1-xmlrpc php7.1-xsl php-yaml php-tideways php-xhprof php-xdebug php-zmq \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Install git
RUN apt-get update \
    && apt-get -y install git \
    && apt-get -y install apache2 \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# MySQL Server
RUN echo 'mysql-server mysql-server/root_password password mysql_pass' | debconf-set-selections
RUN echo 'mysql-server mysql-server/root_password_again password mysql_pass' | debconf-set-selections
RUN apt-get -y install mysql-server --no-install-recommends
RUN sed -ie "s/^bind-address\s*=\s*127\.0\.0\.1$/bind-address = 0.0.0.0/" /etc/mysql/my.cnf 

# PHPMyAdmin
RUN echo 'phpmyadmin phpmyadmin/dbconfig-install boolean true' | debconf-set-selections
RUN echo 'phpmyadmin phpmyadmin/app-password-confirm password phpmyadmin_password ' | debconf-set-selections
RUN echo 'phpmyadmin phpmyadmin/mysql/admin-pass password mysql_pass' | debconf-set-selections
RUN echo 'phpmyadmin phpmyadmin/mysql/app-pass password mysql_pass' | debconf-set-selections
RUN echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | debconf-set-selections
RUN /etc/init.d/mysql start; apt-get -y install phpmyadmin --no-install-recommends

RUN apt-get clean
VOLUME [ "/var/log/mysql/", "/var/log/apache2/" ]



CMD service apache2 start; mysqld_safe






WORKDIR ./
COPY . /var/www/html
EXPOSE 8181
EXPOSE 3306

