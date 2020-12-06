FROM nginx:1.19.5

RUN useradd -u 1001 app \
 && mkdir -p /var/run/nginx /var/tmp/nginx /app \
 && chown -R app:app /usr/share/nginx /var/run/nginx /var/tmp/nginx /app
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/conf.d/default.conf /etc/nginx/conf.d/
USER app:app
