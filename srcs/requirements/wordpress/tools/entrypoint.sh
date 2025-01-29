#!/bin/sh

# Checking WordPress installation
if [ ! -f /var/www/wordpress/wp-config.php ]; then
    echo "WordPress configuration..."
    
    # Download Wordpress configuration file
    cp /var/www/wordpress/wp-config-sample.php /var/www/wordpress/wp-config.php
    
    sed -i "s/database_name_here/${MYSQL_DATABASE}/" /var/www/wordpress/wp-config.php
    sed -i "s/username_here/${MYSQL_USER}/" /var/www/wordpress/wp-config.php
    sed -i "s/password_here/${MYSQL_PASSWORD}/" /var/www/wordpress/wp-config.php
    sed -i "s/localhost/mariadb/" /var/www/wordpress/wp-config.php

    echo "WordPress has been configured."
fi

# Launch PHP-FPM in foreground mode
exec php-fpm81 -F --nodaemonize
