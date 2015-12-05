FROM php:5.6
MAINTAINER Robert

#get m2 required php extensions
RUN apt-get update && apt-get install -y \
    php5-mcrypt php5-curl php5-cli php5-mysql \
	php5-gd php5-intl php5-xsl

#git for fetching magento2 git repository	
RUN apt-get install -y git apache2 && apt-get purge 

#fetch  magneto2 docs
RUN rm -fR /var/www/html/* && git clone https://github.com/magento/magento2.git /var/www/html

#get composer
RUN cd / && curl -sS https://getcomposer.org/installer | php5

#replace with your own if u like
COPY auth.json  /root/.composer/auth.json
RUN cd /var/www/html/ && php5 /composer.phar install

#enable apache2 rewrite
RUN a2enmod rewrite && sed -n '166s/None/All/' /etc/apache2/apache2.conf 

EXPOSE 80
CMD ["service apache2 start"]
	
