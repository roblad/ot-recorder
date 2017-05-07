#FROM armhf/alpine
FROM resin/amd64-alpine
MAINTAINER RL

COPY entrypoint.sh /entrypoint.sh
COPY config.mk /config.mk

ENV VERSION=0.6.9

RUN apk add --no-cache --virtual .build-deps \
        curl-dev libconfig-dev make \
        gcc musl-dev mosquitto-dev libsodium-dev libconfig-dev wget \
    && apk add --no-cache \
        libcurl libconfig mosquitto-libs ca-certificates mosquitto mosquitto-clients mc unzip openssh sshpass openssh-client bash iptables rsyslog fail2ban supervisor bash-completion screen \
    && update-ca-certificates \
    && mkdir -p /usr/local/source \
    && cd /usr/local/source \
    && wget https://github.com/owntracks/recorder/archive/$VERSION.tar.gz \
    && tar xzf $VERSION.tar.gz \
    && cd recorder-$VERSION \
    && mv /config.mk ./ \
    && make \
    && make install \
    && cd / \
    && chmod 755 /entrypoint.sh \
    && rm -rf /usr/local/source \
	&& rm -rf /var/cache/apk/* \
    && apk del .build-deps
RUN echo "root:toor" | chpasswd	
COPY mosquitto.conf /etc/mosquitto/mosquitto.conf
COPY recorder.conf /etc/owntracks/recorder.conf
COPY sshd_config /etc/ssh/sshd_config
COPY .bashrc /root/.bashrc
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN rm /bin/sh && ln -sf /bin/bash /bin/sh && \
    cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local && \
    mkdir -p /var/run/fail2ban
#ENTRYPOINT ["/usr/sbin/mosquitto -d -c /etc/mosquitto/mosquitto.conf"]
VOLUME ["/var/lib/ot-recorder/store/", "/etc/mosquitto/", "/usr/share/ot-recorder/htdocs/" ,"/etc/owntracks/"]
EXPOSE 8083 1883

ENTRYPOINT ["/entrypoint.sh"]


ENTRYPOINT ["/entrypoint.sh"]
#docker build --no-cache=true --compress=true -t robowntracks/owntracks-alpine:amd64 .
#docker run -ti  --name=ot-recorder -p 8084:8083 -p 1884:1883 -v /ot-recorder/htdocs:/usr/share/ot-recorder/htdocs -v /ot-recorder/store:/var/lib/ot-recorder/store robowntracks/owntracks-alpine:amd64 