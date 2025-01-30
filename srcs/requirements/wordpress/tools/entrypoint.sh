#!/bin/sh

while ! mysqladmin ping \
    -h"${WORDPRESS_DB_HOST}" \
    -u"${WORDPRESS_DB_USER}" \
    -p"${WORDPRESS_DB_PASSWORD}" \
    --silent; do
    echo "Waiting for MariaDB..."
    sleep 2
done
echo "MariaDB is ready !"

# Checking WordPress installation
if ! wp core is-installed --allow-root; then
	echo "WordPress configuration..."
    
 	# Download Wordpress configuration file
	# wp core download --allow-root

    wp config create --dbname="${WORDPRESS_DB_NAME}" \
                     --dbuser="${WORDPRESS_DB_USER}" \
                     --dbpass="${WORDPRESS_DB_PASSWORD}" \
                     --dbhost="${WORDPRESS_DB_HOST}" --allow-root

    wp core install --url="https://${DOMAIN_NAME}" \
                    --title="${WORDPRESS_SITE_TITLE}" \
                    --admin_user="${WORDPRESS_ADMIN_USER}" \
                    --admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
					--admin_email="${WORDPRESS_ADMIN_EMAIL}" --allow-root

	echo "WordPress has been successfuly installed."
else
	echo "WordPress is already installed."
fi


sed -i "s/127.0.0.1/0.0.0.0/" /etc/php81/php-fpm.d/www.conf

# Launch PHP-FPM in foreground mode
exec php-fpm81 -F --nodaemonize
