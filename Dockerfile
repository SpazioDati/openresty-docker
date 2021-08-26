FROM debian:buster-slim

MAINTAINER Davide Setti <davide.setti@gmail.com>

# Set environment.
ENV \
  DEBIAN_FRONTEND=noninteractive \
  TERM=xterm-color

# Install packages.
RUN apt-get update && apt-get -y install \
  build-essential \
  curl \
  libreadline-dev \
  libncurses5-dev \
  libpcre3-dev \
  libssl-dev \
  zlib1g-dev \
  perl

# Compile openresty from source.
RUN \
  curl -O https://openresty.org/download/openresty-1.19.9.1.tar.gz && \
  tar -xzvf openresty-*.tar.gz && \
  rm -f openresty-*.tar.gz && \
  cd openresty-* && \
  ./configure --with-pcre-jit && \
  make && \
  make install && \
  make clean && \
  cd .. && \
  rm -rf openresty-* && \
  ln -s /usr/local/openresty/nginx/sbin/nginx /usr/local/bin/nginx && \
  ldconfig

# Set the working directory.
WORKDIR /home/openresty

# Add files to the container.
ADD . /home/openresty

# Set the entrypoint script.
ENTRYPOINT ["./entrypoint"]

# Graceful shutdown
STOPSIGNAL SIGQUIT

# Define the default command.
CMD ["nginx", "-c", "/etc/nginx/nginx.conf"]
