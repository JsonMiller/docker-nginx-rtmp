# Use the official nginx base image
FROM debian

# Install build dependencies
RUN apt-get update && apt-get install build-essential libpcre3 libpcre3-dev libssl-dev zlib1g -y
#

# Copy your custom NGINX configuration

RUN rm -rf /etc/nginx

COPY /nginx-rtmp-module-1.2.2.tar.gz /nginx-1.24.0.tar.gz /etc/nginx/

WORKDIR /etc/nginx

RUN tar -xvzf nginx-rtmp-module-1.2.2.tar.gz
RUN tar -xvzf nginx-1.24.0.tar.gz

WORKDIR /etc/nginx/nginx-1.24.0

RUN ./configure --with-http_ssl_module --without-http_gzip_module --add-module=../nginx-rtmp-module-1.2.2

RUN make

RUN make install

COPY /nginx.conf /usr/local/nginx/conf/

# Expose the RTMP and HTTP ports
EXPOSE 1935
EXPOSE ${PORT}

# Start NGINX
CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]
