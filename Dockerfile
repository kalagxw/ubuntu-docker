FROM       ubuntu:18.04
MAINTAINER Kalagxw

RUN apt-get update

RUN apt-get install --no-install-recommends -y htop git-core openssh-server gettext build-essential autoconf libtool libpcre3-dev asciidoc xmlto libev-dev libc-ares-dev automake libmbedtls-dev libsodium-dev libevent-dev libncurses5-dev make autoconf automake pkg-config  build-essential autoconf libtool libssl-dev libpcre3-dev libev-dev asciidoc xmlto automake nano
RUN mkdir /var/run/sshd

RUN echo 'root:root' |chpasswd
RUN sed -ri 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN set -ex \
&& git clone https://github.com/tmux/tmux.git /home/source/tmux && cd /home/source/tmux && sh autogen.sh && ./configure && make && make install \
&& git clone https://github.com/shadowsocks/simple-obfs.git /home/source/simple-obfs && cd /home/source/simple-obfs && git submodule update --init --recursive && ./autogen.sh && ./configure && make && make install \
&& git clone https://github.com/shadowsocks/shadowsocks-libev.git /home/source/shadowsocks-libev && cd /home/source/shadowsocks-libev && git submodule update --init --recursive && ./autogen.sh && ./configure && make && make install

EXPOSE 22

CMD    ["/usr/sbin/sshd", "-D"]
