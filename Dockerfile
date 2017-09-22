FROM debian:stretch


RUN apt-get -qq update \
    && apt-get -y install zlib1g-dev uuid-dev libmnl-dev gcc make curl git autoconf autogen automake pkg-config netcat-openbsd jq \
    && apt-get -y install autoconf-archive lm-sensors nodejs python python-mysqldb python-yaml \
    && apt-get -y install ssmtp mailutils apcupsd

RUN git clone https://github.com/firehol/netdata.git /netdata.git \
    && cd /netdata.git \
    && ./netdata-installer.sh --dont-wait --dont-start-it \
    && cd / \
    && rm -rf /netdata.git

RUN dpkg -P zlib1g-dev uuid-dev libmnl-dev gcc make git autoconf autogen automake pkg-config \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


RUN ln -sf /dev/stdout /var/log/netdata/access.log \
    && ln -sf /dev/stdout /var/log/netdata/debug.log \
    && ln -sf /dev/stderr /var/log/netdata/error.log

WORKDIR /

ENV NETDATA_PORT 19999
EXPOSE $NETDATA_PORT

CMD /usr/sbin/netdata -D -s /host -p ${NETDATA_PORT}
