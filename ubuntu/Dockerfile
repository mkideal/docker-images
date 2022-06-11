#
# Build development environment based on ubuntu
#

FROM ubuntu:22.04

RUN echo "Installing basic softwares..." \
	&& apt upgrade \
	&& apt update \
	&& apt install -y openssh-server \
    && apt install -y apt-utils \
    && apt install -y exuberant-ctags \
    && apt install -y unzip \
    && apt install -y vim \
    && apt install -y iptables \
    && apt install -y telnet \
    && apt install -y net-tools \
    && apt install -y tcpdump \
	&& apt install -y wget \
	&& apt install -y curl \
    && apt install -y git \
	&& apt install -y make \
	&& apt install -y autoconf \
	&& apt install -y libtool \
	&& apt install -y gcc g++ \
	&& apt install -y cmake \
	&& apt install -y pwgen \
	&& apt install -y pkg-config \
	&& apt install -y cron

RUN echo "Initializing sshd..." \
	&& mkdir /var/run/sshd \
	&& sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
	&& sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config \
	&& sed -i '/pam_loginuid.so/c session    optional     pam_loginuid.so'  /etc/pam.d/sshd

EXPOSE 22

RUN echo "Initalizing time,locale,user password,..." \
	&& echo root:123456 | chpasswd

# Create user
ENV DEV_USERNAME=dev
ENV DEV_HOME=/home/dev

COPY ../res/bashrc /tmp/
COPY ../res/gitconfig /tmp/gitconfig

RUN echo "Creating developer user ${DEV_USERNAME}..." \
	&& useradd -ms /bin/bash ${DEV_USERNAME} && echo ${DEV_USERNAME}:123456 | chpasswd \
	&& cat /tmp/bashrc >> ${DEV_HOME}/.bashrc \
	&& cp /tmp/gitconfig ${DEV_HOME}/.gitconfig \
	&& chown ${DEV_USERNAME}:${DEV_USERNAME} ${DEV_HOME}/.bashrc \
	&& chown ${DEV_USERNAME}:${DEV_USERNAME} ${DEV_HOME}/.gitconfig

RUN apt install -y bash-completion \
	&& apt install -y sudo \
	&& echo "${DEV_USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

ENV GO_VERSION=1.18.1

RUN echo "Installing go${GO_VERSION}..." \
	&& cd /tmp/ \
	&& wget https://go.dev/dl/go${GO_VERSION}.linux-arm64.tar.gz \
	&& tar zxf go${GO_VERSION}.linux-arm64.tar.gz \
	&& mv go /usr/local/ \
	&& rm go*.tar.gz


RUN echo "Done!"

CMD /usr/sbin/sshd -D
