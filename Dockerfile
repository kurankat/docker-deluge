FROM ubuntu:xenial

ARG BUILD_DATE
ARG VERSION
LABEL maintainer="github/kurankat"

RUN apt-get update && apt-get -y --no-install-recommends install software-properties-common curl \
    && add-apt-repository ppa:deluge-team/ppa \
    && apt-get update \
    && apt-get -y --no-install-recommends install deluged deluge-web deluge-console \
    && useradd -m deluge
    
COPY entrypoint.sh /

RUN chmod +x /entrypoint.sh 

EXPOSE 8112 58846 58946 58946/udp
VOLUME /home/deluge/.config/deluge /home/deluge/Downloads

ENTRYPOINT ["/entrypoint.sh"]
