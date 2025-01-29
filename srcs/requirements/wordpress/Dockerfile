FROM alpine:3.18

RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.18/main" > /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/v3.18/community" >> /etc/apk/repositories

RUN apk update && apk add --no-cache \
	php php-common php-fpm php-mysqli php-json php-session php-zlib php-gd \
    php-mbstring php-openssl php-curl php-dom wget tar

RUN mkdir -p /var/www/wordpress

RUN wget https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz && \
    tar -xzf /tmp/wordpress.tar.gz -C /var/www/wordpress --strip-components=1 && \
    rm /tmp/wordpress.tar.gz

COPY tools/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
