FROM  centos:7
LABEL ali.lotfi.linux@gmail.com
RUN yum install -y httpd \
    zip\
    unzip
ADD https://www.free-css.com/assets/files/free-css-templates/download/page293/hostit.zip /var/www/html/
WORKDIR /var/www/html/
RUN unzip hostit.zip
RUN cp -rvf hostit-html/* .
RUN rm -rf hostit-html hostit.zip
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
EXPOSE 80
