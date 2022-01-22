FROM alpine:latest
ENV myworkdir /var/www/localhost/htdocs
ARG whoami=Sam
WORKDIR ${myworkdir}
RUN apk --update add apache2
RUN rm -rf /var/cache/apk/* 
RUN echo "<h3>I am ${whoami}. I am taking this great Docker Course. Round 01<h3>" >> index.html
RUN echo "<h3>I am ${whoami}. I am taking this great Docker Course. Round 02<h3>" >> index.html
RUN echo "<h3>I am ${whoami}. I am taking this great Docker Course. Round 03<h3>" >> index.html
ENTRYPOINT ["httpd", "-D", "FOREGROUND"]