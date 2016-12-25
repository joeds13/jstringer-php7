FROM 145351228327.dkr.ecr.eu-west-1.amazonaws.com/ubuntu16:0.3.0
MAINTAINER Joe Stringer <joe@stringer.sh>
RUN apt update && \
    # TODO install php7.1 and nginx mainline
    apt install -y php7.0-curl php7.0-fpm php7.0-zip nginx && \
    apt clean
RUN mkdir /run/php
# TODO php configs
# date.timezone = Europe/London
RUN EXPECTED_SIGNATURE=$(curl -q https://composer.github.io/installer.sig); \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"; \
    ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');"); \
    if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]; then >&2 echo 'ERROR: Invalid installer signature'; rm composer-setup.php; exit 1; fi; \
    php composer-setup.php --quiet; \
    RESULT=$?; \
    mv /composer.phar /usr/bin/composer; \
    rm composer-setup.php; \
    exit $RESULT
RUN composer global require "hirak/prestissimo:^0.3"
