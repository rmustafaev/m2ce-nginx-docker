FROM nginx:1.12

#Copy configuration and operation files
COPY ./conf/* /etc/nginx/
COPY ./bin/start.sh /usr/local/bin/
RUN apt-get update && apt-get install -y python-openssl \
  python-crypto \
  python-setuptools \
  python-pip && \
  pip install acme-nginx

WORKDIR /srv/www

CMD ["/usr/local/bin/start.sh"]
