#!/bin/sh

while ! mysqladmin ping -h"$WORDPRESS_DB_HOST" \
						-u"$WORDPRESS_DB_USER" \
						-p"$WORDPRESS_DB_PASSWORD" --silent; do
  echo "Waiting for MariaDB..."
  sleep 2
done
echo "MariaDB is ready !"

if [ ! -f "$WORDPRESS_PATH/wp-includes/version.php" ]; then
  echo "Downloading WordPress..."
  wp core download --allow-root --path="$WORDPRESS_PATH"
fi

if [ ! -f "$WORDPRESS_PATH/wp-config.php" ]; then
  echo "WordPress configuration..."
  wp config create \
    --path="$WORDPRESS_PATH" \
    --dbname="$WORDPRESS_DB_NAME" \
    --dbuser="$WORDPRESS_DB_USER" \
    --dbpass="$WORDPRESS_DB_PASSWORD" \
    --dbhost="$WORDPRESS_DB_HOST" \
    --allow-root
fi

if ! wp core is-installed --path="$WORDPRESS_PATH" --allow-root; then
  wp core install \
    --path="$WORDPRESS_PATH" \
    --url="https://${DOMAIN_NAME}" \
    --title="${WORDPRESS_SITE_TITLE}" \
    --admin_user="${WORDPRESS_ADMIN_USER}" \
    --admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
    --admin_email="${WORDPRESS_ADMIN_EMAIL}" \
    --skip-email \
    --allow-root
  
  echo "WordPress has been successfully installed."
else
  echo "WordPress is already installed."
fi

if ! wp user get "$WORDPRESS_RANDOM_USER" --path="$WORDPRESS_PATH" --allow-root > /dev/null 2>&1; then
    wp user create "$WORDPRESS_RANDOM_USER" "$WORDPRESS_RANDOM_EMAIL" \
      --role="subscriber" \
      --user_pass="$WORDPRESS_RANDOM_PASS" \
      --path="$WORDPRESS_PATH" \
      --allow-root
else
    echo "User $WORDPRESS_RANDOM_USER has already been created."
fi

sed -i "s/127.0.0.1/0.0.0.0/" /etc/php81/php-fpm.d/www.conf

exec php-fpm81 -F --nodaemonize
