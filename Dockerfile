FROM ubuntu:xenial

ARG BUILD_DATE
ARG VERSION
LABEL maintainer="github/kurankat"

RUN apt update && apt -y install software-properties-common \
    && add-apt-repository ppa:deluge-team/ppa \
    && apt update \
    && apt -y install deluged deluge-web deluge-console

COPY root/ /
COPY entrypoint.sh /

RUN chmod +x /entrypoint.sh

EXPOSE 8112 58846 58946 58946/udp
VOLUME /root/.config/deluge /root/Downloads

ENTRYPOINT ["/entrypoint.sh"]
