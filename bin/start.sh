#!/bin/bash
[ ! -z "${PHP_HOST}" ]                 && sed -i "s/PHP_HOST/${PHP_HOST}/" /etc/nginx/conf.d/mage.conf
[ ! -z "${PHP_PORT}" ]                 && sed -i "s/PHP_PORT/${PHP_PORT}/" /etc/nginx/conf.d/mage.conf
[ ! -z "${APP_MAGE_MODE}" ]            && sed -i "s/APP_MAGE_MODE/${APP_MAGE_MODE}/" /etc/nginx/conf.d/mage.conf
[ ! -z "${DOMAIN_NAME}" ]              && sed -i "s/DOMAIN_NAME/${DOMAIN_NAME}/" /etc/nginx/conf.d/mage.conf
[ ! -z "${WWW_DIR}" ]                  && sed -i "s~WWW_DIR~${WWW_DIR}~" /etc/nginx/conf.d/mage.conf

#Generate certificate via let`s encrypt and renew it every 15th of month
/usr/local/bin/acme-nginx -d ${DOMAIN_NAME} -d www.${DOMAIN_NAME}

cat <<EOF | crontab -u -
30 2 15 * * /usr/local/bin/acme-nginx -d ${DOMAIN_NAME} -d www.${DOMAIN_NAME} >> /var/log/letsencrypt.log 2>&1
EOF

/usr/sbin/nginx -g "daemon off;"
