#!/bin/bash
sed -i "s/PHP_HOST/${PHP_HOST:-phpfpm}/" /etc/nginx/conf.d/mage.conf
sed -i "s/PHP_PORT/${PHP_PORT:-9000}/" /etc/nginx/conf.d/mage.conf
sed -i "s/APP_MAGE_MODE/${APP_MAGE_MODE:-default}/" /etc/nginx/conf.d/mage.conf
sed -i "s/DOMAIN_NAME/${DOMAIN_NAME:-localhost}/" /etc/nginx/conf.d/mage.conf
sed -i "s/WWW_DIR/${WWW_DIR:-/srv/www}/" /etc/nginx/conf.d/mage.conf

DOMAIN_NAME=${DOMAIN_NAME:-localhost}
echo -e "Domain is ${DOMAIN_NAME}"

#Generate certificate via let`s encrypt and renew it every 15th of month
/usr/local/bin/acme-nginx -d ${DOMAIN_NAME} -d www.${DOMAIN_NAME}

cat <<EOF | crontab -u root -
30 2 15 * * /usr/local/bin/acme-nginx -d ${DOMAIN_NAME} -d www.${DOMAIN_NAME} && service nginx reload >> /var/log/letsencrypt.log 2>&1
EOF

# Start the cron service
/usr/sbin/cron

# Start the nginx service
/usr/sbin/nginx -g "daemon off;"
