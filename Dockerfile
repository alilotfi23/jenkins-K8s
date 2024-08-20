FROM centos:7

LABEL maintainer="ali.lotfi.linux@gmail.com"

# Install necessary packages and clean up yum caches to reduce image size
RUN yum install -y httpd \
    zip \
    unzip && \
    yum clean all

# Download and extract the template directly into the web server root
ADD https://www.free-css.com/assets/files/free-css-templates/download/page293/hostit.zip /tmp/hostit.zip

WORKDIR /var/www/html/

# Extract the template, move files, and clean up unnecessary files
RUN unzip /tmp/hostit.zip -d /tmp/ && \
    cp -rvf /tmp/hostit-html/* . && \
    rm -rf /tmp/hostit-html /tmp/hostit.zip

# Expose the HTTP port
EXPOSE 80

# Start Apache in the foreground
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]

