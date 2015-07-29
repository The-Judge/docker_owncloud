FROM derjudge/apache-php
MAINTAINER Marc Richter <mail@marc-richter.info>

RUN apt-get update
RUN apt-get install -y wget

# Add package source for oc
RUN echo 'deb http://download.opensuse.org/repositories/isv:/ownCloud:/community/xUbuntu_14.04/ /' > /etc/apt/sources.list.d/owncloud.list
RUN wget -O - http://download.opensuse.org/repositories/isv:ownCloud:community/xUbuntu_14.04/Release.key | apt-key add -
RUN apt-get update

# Install OwnCloud
RUN apt-get install -y owncloud \
    owncloud-app-activity \
    owncloud-app-encryption \
    owncloud-app-files \
    owncloud-app-files-pdfviewer \
    owncloud-app-files-sharing \
    owncloud-app-files-texteditor \
    owncloud-app-files-trashbin \
    owncloud-app-files-versions \
    owncloud-app-files-videoviewer \
    owncloud-app-firstrunwizard \
    owncloud-app-gallery \
    owncloud-config-apache \
    libav-tools \
    php5-imagick

# Make seetings
RUN rm -f /etc/apache2/conf-enabled/owncloud.conf /etc/apache2/sites-enabled/000-default.conf
RUN echo '<VirtualHost *:80>' > /etc/apache2/sites-available/owncloud.conf ; \
    cat /etc/apache2/conf-available/owncloud.conf | grep -v Alias >> /etc/apache2/sites-available/owncloud.conf ; \
    echo 'ServerAdmin sysadmin@in-telegence.net' >> /etc/apache2/sites-available/owncloud.conf ; \
    echo 'Header always add Strict-Transport-Security "max-age=15768000; includeSubDomains; preload"' >> /etc/apache2/sites-available/owncloud.conf ; \
    echo 'DocumentRoot /var/www/owncloud' >> /etc/apache2/sites-available/owncloud.conf ; \
    echo 'ErrorLog ${APACHE_LOG_DIR}/error.log' >> /etc/apache2/sites-available/owncloud.conf ; \
    echo 'CustomLog ${APACHE_LOG_DIR}/access.log combined' >> /etc/apache2/sites-available/owncloud.conf ; \
    echo '</VirtualHost>' >> /etc/apache2/sites-available/owncloud.conf
RUN ln -s ../sites-available/owncloud.conf /etc/apache2/sites-enabled/owncloud.conf

# Cronjob
rm -f /etc/php5/cli/conf.d/20-snmp.ini /etc/php5/apache2/conf.d/20-snmp.ini
if [ -f /extra/www-data.crontab ]; then
    crontab -u www-data /extra/www-data.crontab
fi

a2enmod headers

EXPOSE 80
CMD ["/run.sh"]
