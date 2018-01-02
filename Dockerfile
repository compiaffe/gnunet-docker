FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive
ENV GNURL_GIT_URL https://git.taler.net/gnurl.git
ENV GNURL_GIT_BRANCH gnurl-7.54.0
ENV GNUNET_GIT_URL https://gnunet.org/git/gnunet
ENV GNUNET_GIT_BRANCH master

# Install tools and dependencies
RUN apt-get update && \
    apt-get -y install --no-install-recommends \
      ca-certificates \
      libsasl2-modules \
      git \
      automake \
      autopoint \
      autoconf \
      texinfo \
      libtool \
      libltdl-dev \
      libgpg-error-dev \
      libidn11-dev \
      libunistring-dev \
      libglpk-dev \
      libbluetooth-dev \
      libextractor-dev \
      libmicrohttpd-dev \
      libgnutls28-dev \
      libgcrypt20-dev \
      libpq-dev \
      libsqlite3-dev && \
    apt-get clean all && \
    apt-get -y autoremove && \
    rm -rf \
      /var/lib/apt/lists/* \
      /tmp/*

# Install GNUrl
RUN git clone $GNURL_GIT_URL \
      --branch $GNURL_GIT_BRANCH \
      --depth=1 \
      --quiet && \
    cd /gnurl && \
      autoreconf -i && \
      ./configure \
        --enable-ipv6 \
        --with-gnutls \
        --without-libssh2 \
        --without-libmetalink \
        --without-winidn \
        --without-librtmp \
        --without-nghttp2 \
        --without-nss \
        --without-cyassl \
        --without-polarssl \
        --without-ssl \
        --without-winssl \
        --without-darwinssl \
        --disable-sspi \
        --disable-ntlm-wb \
        --disable-ldap \
        --disable-rtsp \
        --disable-dict \
        --disable-telnet \
        --disable-tftp \
        --disable-pop3 \
        --disable-imap \
        --disable-smtp \
        --disable-gopher \
        --disable-file \
        --disable-ftp \
        --disable-smb && \
      make install && \
    cd -

# Create GNUnet user and group
RUN adduser \
      --system \
      --home /var/lib/gnunet \
      --group \
      --disabled-password \
      gnunet && \
    addgroup \
      --system \
      gnunetdns

# Install GNUnet
RUN git clone $GNUNET_GIT_URL \
      --branch $GNUNET_GIT_BRANCH \
      --depth=1 \
      --quiet && \
    cd /gnunet && \
      ./bootstrap && \
      ./configure --with-nssdir=/lib && \
      make && \
      make install && \
      ldconfig && \
    cd -

# Configure GNUnet
RUN echo '[arm]\nSYSTEM_ONLY = YES\nUSER_ONLY = NO\n' > /etc/gnunet.conf && \
    cat /etc/gnunet.conf && \
    ldconfig

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod 755 /usr/local/bin/docker-entrypoint

USER gnunet

ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]
