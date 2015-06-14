# nginx-rtmp-server
===================


This repository contains **Dockerfile** of [Nginx](http://nginx.org/) compiled with the excellent [nginx-rtmp-module](https://github.com/arut/nginx-rtmp-module) for [Docker](https://www.docker.com/)'s [automated build](https://registry.hub.docker.com/u/dockerfile/nginx/) published to the public [Docker Hub Registry](https://registry.hub.docker.com/).

*Not published yet.*


### Base Docker Image

* [ubuntu](https://registry.hub.docker.com/_/ubuntu/)


### Installation

1. Install [Docker](https://www.docker.com/).

2. Create a nginx.conf in the current folder.

3. Build the image from Dockerfile: `docker build -t nginx_rtmp_server github.com/nomad-live/nginx-rtmp-server`


#### Ubuntu

```bash
sudo apt-get install docker.io
mkdir nginx-rtmp-server
wget https://github.com/nomad-live/nginx-rtmp-server/archive/0.1.0.tar.gz -O - | tar -zxf - --strip=1 -C ./nginx-rtmp-server
cd nginx-rtmp-server
docker build -t nginx_rtmp_server .
```


### Usage

    docker run -d -p 80:80 -p 443:443 -p 1935:1935 nginx_rtmp_server

#### Attach persistent/shared directories

    docker run -d -p 80:80 -p 443:443 -p 1935:1935 -v <sites-enabled-dir>:/etc/nginx/conf.d -v <certs-dir>:/etc/nginx/certs -v <log-dir>:/var/log/nginx -v <html-dir>:/var/www/html nginx_rtmp_server

After few seconds, open `http://<host>` to see the welcome page.