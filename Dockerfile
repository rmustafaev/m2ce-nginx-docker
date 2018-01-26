FROM nginx:1.12

#Copy configuration and operation files
COPY ./conf/* /etc/nginx/
COPY ./bin/start.sh /usr/local/bin/

WORKDIR /srv/www

CMD ["/usr/local/bin/start.sh"]
