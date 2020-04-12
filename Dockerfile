FROM       ubuntu:20.04
MAINTAINER Kalagxw

ENV DEBIAN_FRONTEND=noninteractive
RUN set -eux && \
    apt-get update && \
    apt-get install -y locales tzdata xfonts-wqy && \
    locale-gen zh_CN.UTF-8 && \
    update-locale LANG=zh_CN.UTF-8 LANGUAGE=zh_CN.UTF-8 LC_ALL=zh_CN.UTF-8 && \
    ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    find /var/lib/apt/lists -type f -delete && \
    find /var/cache -type f -delete

RUN apt-get upgrade -y \
&& apt-get install --no-install-recommends -y sudo bison byacc curl psmisc dialog apt-utils ca-certificates htop git openssh-server gettext build-essential autoconf libtool libpcre3-dev asciidoc xmlto libev-dev libc-ares-dev automake libmbedtls-dev libsodium-dev libevent-dev libncurses5-dev make autoconf automake pkg-config  build-essential autoconf libtool libssl-dev libpcre3-dev libev-dev asciidoc xmlto automake nano
RUN mkdir /var/run/sshd

RUN sed -i \
	-e 's~^PasswordAuthentication yes~PasswordAuthentication no~g' \
	-e 's~^#UseDNS yes~UseDNS no~g' \
	/etc/ssh/sshd_config
  
RUN sed -i '/^#Host_Key/'d /etc/ssh/sshd_config
RUN sed -i '/^Host_Key/'d /etc/ssh/sshd_config
RUN echo 'HostKey /etc/ssh/ssh_host_rsa_key'>/etc/ssh/sshd_config

#生成ssh-key与配置ssh-key##
RUN rm -rf /etc/ssh/ssh_host_rsa_key && ssh-keygen -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key
RUN mkdir -p /root/.ssh
RUN echo 'ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAttCOKBNadAC5s4yE5JRIZ24UvZaB6K4mlU+txxAfmfyepuPlJw0Da6YX6iMUqj5iIsaYrCMUjszAsbNomnxfYKwVbFpnVZtMJVLeu1VLhCklYM4Btu0Q+5NalUQzmvmUx3Cc3Cr/BXmTzXVWDeyBGhdFkrMCdspS/xd9SU9wcpcOGxb8bRk3EWQS95ejdEL2S0F3t9E2PWEXrtk3JfWjR3IsY1hSJAAsHAd2/sQasAYktmJhZp2l+/E2NoSvrNrgTMZm5senQYhvAH4jn43ScxWqWbT2SLeGhQ/q0YEouscKoJLLEdijPx+yphh4TU8TDMZe+9oj9XMjAz8EHZqjWQ=='>/root/.ssh/authorized_keys

RUN set -ex \
&& git clone https://github.com/tmux/tmux.git /home/source/tmux && cd /home/source/tmux && sh autogen.sh && ./configure && make && make install \
&& git clone https://github.com/shadowsocks/shadowsocks-libev.git /home/source/shadowsocks-libev && cd /home/source/shadowsocks-libev && git submodule update --init --recursive && ./autogen.sh && ./configure && make && make install
RUN sed -i "/^# some more ls aliases/a\alias tmux='tmux -2 -u'" /root/.bashrc

ENV LANG=zh_CN.UTF-8 LANGUAGE=zh_CN.UTF-8 LC_ALL=zh_CN.UTF-8
EXPOSE 22

CMD    ["/usr/sbin/sshd", "-D"]
