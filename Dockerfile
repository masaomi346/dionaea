FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo

RUN apt update && \
    apt install -y \
    build-essential \
    cmake \
    check \
    cython3 \
    git \
    libcurl4-openssl-dev \
    libemu-dev \
    libev-dev \
    libglib2.0-dev \
    libloudmouth1-dev \
    libnetfilter-queue-dev \
    libnl-3-dev \
    libpcap-dev \
    libssl-dev \
    libtool \
    libudns-dev \
    less \
    python3 \
    python3-dev \
    python3-bson \
    python3-yaml \
    python3-boto3 \
    fonts-liberation && \
    apt autoremove -y && \
    git clone https://github.com/DinoTools/dionaea.git /opt/dionaea && \
    cd  /opt/dionaea && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_INSTALL_PREFIX:PATH=/opt/dionaea .. && \
    make && \
    make install && \
    groupadd --gid 1000 dionaea && \
    useradd -m --uid 1000 --gid 1000 dionaea && \
    chown -R dionaea:dionaea /opt/dionaea/var

COPY dionaea.cfg /opt/dionaea/etc/dionaea/dionaea.cfg
COPY ftp.py /opt/dionaea/lib/dionaea/python/dionaea/
COPY index.html /opt/dionaea/var/lib/dionaea/http/root
COPY smbfields.py /opt/dionaea/lib/dionaea/python/dionaea/smb/include/
COPY mssql.py /opt/dionaea/lib/dionaea/python/dionaea/mssql/
COPY extras.py /opt/dionaea/lib/dionaea/python/dionaea/smb/

EXPOSE 21 42 69/udp 80 135 443 445 1433 1723 1883 1900/udp 3306 5060 5060/udp 5061 11211