FROM node:14.15-alpine as angular

LABEL AUTHOR = TIGOLI FREDERIC
LABEL VERSION = 1.0


WORKDIR /app
COPY . .

RUN npm install -g npm@7 && npm install 
RUN npm run build


FROM centos@sha256:be65f488b7764ad3638f236b7b515b3678369a5124c47b8d32916d6487418ea4 

RUN yum update -y && yum install httpd -y

WORKDIR /var/www/html

COPY --from=angular /app/dist ./lycoris.com/
COPY --from=angular /app/httpd.conf /etc/httpd/conf
COPY --from=angular /app/lycoris.conf /etc/httpd/conf.d

VOLUME ["/var/www/html/", "/etc/httpd/conf", "/etc/httpd/conf.d"]

ENTRYPOINT ["/usr/sbin/httpd","-D","FOREGROUND"]
