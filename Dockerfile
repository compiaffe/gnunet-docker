from ubuntu:16.04

# Install the required build tools
RUN apt-get update && apt-get install -y git automake autopoint autoconf

# Install the required dependencies and libgcrypt
RUN apt-get update && apt-get install -y libltdl-dev libgpg-error-dev libidn11-dev libunistring-dev libglpk-dev libbluetooth-dev libextractor-dev libmicrohttpd-dev libgnutls28-dev libgcrypt20-dev

# Default decision to go with sqlite, missing modules with i.e. postgres
RUN apt-get update && apt-get install -y libpq-dev libsqlite3-dev

# Install gnurl from source at version gnurl-7.54.0
RUN git clone https://git.taler.net/gnurl.git --branch gnurl-7.54.0
WORKDIR /gnurl
RUN autoreconf -i
RUN ./configure --enable-ipv6 --with-gnutls --without-libssh2 \
--without-libmetalink --without-winidn --without-librtmp \
--without-nghttp2 --without-nss --without-cyassl \
--without-polarssl --without-ssl --without-winssl \
--without-darwinssl --disable-sspi --disable-ntlm-wb --disable-ldap \
--disable-rtsp --disable-dict --disable-telnet --disable-tftp \
--disable-pop3 --disable-imap --disable-smtp --disable-gopher \
--disable-file --disable-ftp --disable-smb
RUN make install
WORKDIR /

# Create gnunet user and group
RUN adduser --system --home /var/lib/gnunet --group --disabled-password gnunet
RUN addgroup --system gnunetdns

# Install GNUnet
RUN git clone https://gnunet.org/git/gnunet
WORKDIR /gnunet
RUN ./bootstrap
RUN ./configure --with-nssdir=/lib
RUN make
RUN make install
RUN ldconfig


RUN echo '[arm]\nSYSTEM_ONLY = YES\nUSER_ONLY = NO\n' > /etc/gnunet.conf
RUN cat /etc/gnunet.conf
RUN ldconfig
USER gnunet
