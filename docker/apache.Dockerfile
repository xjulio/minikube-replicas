FROM httpd:latest
LABEL author="xjulio@gmial.com"
LABEL version="1.0"
RUN echo "hello world" > /usr/local/apache2/htdocs/index.html
