FROM asclinux/linuxforphp-8.2-ultimate:7.4-nts
MAINTAINER doug@unlikelysource.com
COPY startup.sh /tmp/startup.sh
COPY secrets.sh /tmp/secrets.sh
COPY install_wp.sh /tmp/install_wp.sh
COPY backup.sh /tmp/backup.sh
COPY restore.sh /tmp/restore.sh
RUN chmod +x /tmp/*.sh
RUN \
    echo "Creating sample database and assigning permissions ..." && \
    source /tmp/secrets.sh && \
    /etc/init.d/mysql start && \
    sleep 3 && \
    mysql -uroot -v -e "CREATE DATABASE IF NOT EXISTS $DB_NAM;" && \
    mysql -uroot -v -e "CREATE USER IF NOT EXISTS '$DB_USR'@'localhost' IDENTIFIED BY '$DB_PWD';" && \
    mysql -uroot -v -e "GRANT ALL PRIVILEGES ON *.* TO '$DB_USR'@'localhost';" && \
    mysql -uroot -v -e "FLUSH PRIVILEGES;"
RUN \
    echo "Installing phpMyAdmin ..." && \
    wget -O /tmp/phpmyadmin_install.sh https://opensource.unlikelysource.com/phpmyadmin_install.sh && \
    chmod +x /tmp/*.sh && \
    /tmp/phpmyadmin_install.sh 5.1.1
RUN \
    echo "Installing WordPress ..." && \
    chmod +x /tmp/*.sh && \
    /tmp/install_wp.sh
RUN \
    echo "Finishing Apache setup ..." && \
    source /tmp/secrets.sh && \
    mv -f /srv/www /srv/www.OLD && \
    ln -sfv $WP_DIR/bedrock/web /srv/www && \
    echo "ServerName $DNS" >> /etc/httpd/httpd.conf && \
    chown -R apache:apache $WP_DIR/bedrock && \
    chmod -R 775 $WP_DIR/bedrock
CMD /tmp/startup.sh
