FROM derjudge/archlinux-apache-php
MAINTAINER Marc Richter <mail@marc-richter.info>

RUN yes | pacman -Syy | cat
RUN yes | pacman -S \
    ffmpeg \
    libreoffice-fresh \
    libx264 \
    owncloud \
    smbclient \
    | cat

# Make seetings
RUN mkdir -p /etc/httpd/conf/sites-available /etc/httpd/conf/sites-enabled
ADD assets/apache_config.conf /etc/httpd/conf/sites-available/owncloud.conf
RUN ln -s ../sites-available/owncloud.conf /etc/httpd/conf/sites-enabled/owncloud.conf

# Cronjob
RUN if [ -f /extra/http.crontab ]; then crontab -u http /extra/http.crontab ; fi

# Add default extra - script
RUN if [ ! -e /extra ]; then mkdir /extra; fi
RUN if [ ! -e /extra/init ]; then mv /extra/init /extra/init_user; fi
ADD assets/extra/init /extra/init
RUN chmod +x /extra/init*

VOLUME ["/app"]
EXPOSE 80

CMD ["/run.sh"]
