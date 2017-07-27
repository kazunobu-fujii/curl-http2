FROM gliderlabs/alpine:edge

MAINTAINER Kazunobu FUJII

ENV CURL_VERSION 7.54.1

RUN apk add --update --no-cache openssl openssl-dev nghttp2-dev ca-certificates

RUN apk add --update --no-cache --virtual curldeps g++ make perl && \
  wget https://curl.haxx.se/download/curl-$CURL_VERSION.tar.bz2 && \
  tar xjvf curl-$CURL_VERSION.tar.bz2 && \
  rm curl-$CURL_VERSION.tar.bz2 && \
  cd curl-$CURL_VERSION && \
  ./configure \
    --with-nghttp2=/usr \
    --prefix=/usr \
    --with-ssl \
    --enable-ipv6 \
    --enable-unix-sockets \
    --without-libidn \
    --disable-static \
    --disable-ldap \
    --with-pic && \
  make && \
  make install && \
  cd / && \
  rm -r curl-$CURL_VERSION && \
  rm -r /var/cache/apk && \
  rm -r /usr/share/man && \
  apk del curldeps

WORKDIR /run
ENTRYPOINT ["/usr/bin/curl"]
CMD ["--version"]
