FROM derjudge/apache-php
MAINTAINER Marc Richter <mail@marc-richter.info>

RUN apt-get update
RUN apt-get install -y wget

# Add package source for oc
RUN echo 'deb http://download.opensuse.org/repositories/isv:/ownCloud:/community/xUbuntu_14.04/ /' > /etc/apt/sources.list.d/owncloud.list
RUN wget -O - http://download.opensuse.org/repositories/isv:ownCloud:community/xUbuntu_14.04/Release.key | apt-key add -
RUN apt-get update

# Install OwnCloud
RUN apt-get install -y libav-tools \
    owncloud \
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
    php5-imagick \
    rsync

# Make seetings
RUN rm -f /etc/apache2/conf-enabled/owncloud.conf /etc/apache2/sites-enabled/000-default.conf
ADD assets/apache_config.conf /etc/apache2/sites-available/owncloud.conf
RUN ln -s ../sites-available/owncloud.conf /etc/apache2/sites-enabled/owncloud.conf

# Cronjob
RUN rm -f /etc/php5/cli/conf.d/20-snmp.ini /etc/php5/apache2/conf.d/20-snmp.ini
RUN if [ -f /extra/www-data.crontab ]; then crontab -u www-data /extra/www-data.crontab ; fi

RUN a2enmod headers

# Add default extra - script
RUN mkdir /extra
ADD assets/extra/init /extra/init
RUN chmod +x /extra/init

VOLUME ["/app"]

EXPOSE 80
CMD ["/run.sh"]
