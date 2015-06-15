FROM ubuntu

MAINTAINER cadesalaberry

#ADD docker/install /install
#RUN chmod 755 /install
#RUN /install

ENV NGINX_PATH=/etc/nginx
ENV NGINX_VERSION=1.9.1
ENV RTMP_VERSION=1.1.7


# Installs build dependencies.
RUN apt-get update && apt-get install -y \
    build-essential \
    libpcre3 \
    libpcre3-dev \
    libssl-dev \
    wget

# Uses highest number of cores for the build.
RUN alias make="make -j$(nproc)"

# Downloads nginx-rtmp-module.
RUN mkdir /tmp/nginx-rtmp-module
RUN wget https://github.com/arut/nginx-rtmp-module/archive/v${RTMP_VERSION}.tar.gz -O - | tar -zxf - --strip=1 -C /tmp/nginx-rtmp-module

# Downloads nginx.
RUN mkdir -p /tmp/nginx
RUN wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz -O - | tar -zxf - -C /tmp/nginx --strip=1

WORKDIR /tmp/nginx

# Compiles nginx with the nginx-rtmp-module.
#    --prefix=/usr/local/nginx \
RUN ./configure \
    --prefix=${NGINX_PATH} \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --http-log-path=/var/log/nginx/access.log \
    --error-log-path=/var/log/nginx/error.log \
    --lock-path=/var/lock/nginx.lock \
    --pid-path=/var/run/nginx.pid \
    --with-http_stub_status_module \
    --with-http_ssl_module \
    --with-ipv6 \
    --add-module=/tmp/nginx-rtmp-module

RUN make && make install

#############
# Docker fix
# http://stackoverflow.com/questions/18861300/how-to-run-nginx-within-docker-container-without-halting
#############
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf

# Deletes the apt-get cache to lighten up the image.
RUN rm -rf /var/lib/apt/lists/*

# Uses the provided nginx config file.
COPY nginx.conf /etc/nginx/nginx.conf

# Moves back to the interesting folder in case of login.
WORKDIR ${NGINX_PATH}

# Define default command.
CMD ["nginx"]

# Opens HTTP, HTTPS and RTMP ports.
EXPOSE 80
EXPOSE 443
EXPOSE 1935