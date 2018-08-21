#
# Build development environment based on ubuntu
#

FROM ubuntu:18.04

ENV GO_VERSION=1.10.3

COPY ./res/bashrc /tmp/
COPY ./res/vimrc /tmp/
COPY ./res/gitconfig /tmp/gitconfig

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
    && apt install -y redis-server \
    && apt install -y nginx \
    && apt install -y git \
	&& apt install -y make \
	&& apt install -y autoconf \
	&& apt install -y libtool \
	&& apt install -y gcc g++ \
	&& apt install -y cmake \
	&& apt install -y pwgen \
	&& apt install -y pkg-config \
	&& apt install -y rsyslog rsyslog-kafka \
	&& apt install -y cron

RUN echo "Initializing sshd..." \
	&& mkdir /var/run/sshd \
	&& sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
	&& sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config \
	&& sed -i '/pam_loginuid.so/c session    optional     pam_loginuid.so'  /etc/pam.d/sshd

EXPOSE 22

RUN echo "Initalizing time,locale,user password,..." \
	&& echo root:123456 | chpasswd

RUN echo "Installing go${GO_VERSION}..." \
	&& cd /tmp/ \
	&& wget https://google-dl-agent.gopherd.com/go/go${GO_VERSION}.linux-amd64.tar.gz \
	&& tar zxf go${GO_VERSION}.linux-amd64.tar.gz \
	&& mv go /usr/local/ \
	&& rm go*.tar.gz

RUN echo "Installing mysql..." \
	&& echo "mysql-server mysql-server/root_password password 123456" | debconf-set-selections \
	&& echo "mysql-server mysql-server/root_password_again password 123456" | debconf-set-selections \
	&& apt -y install mysql-server

RUN mkdir -p /var/lib/mysql \
	&& chown -R mysql:mysql /var/lib/mysql
VOLUME /var/lib/mysql

ENV DEV_USERNAME=dev
ENV DEV_HOME=/home/dev
RUN echo "Creating developer user ${DEV_USERNAME}..." \
	&& useradd -ms /bin/bash ${DEV_USERNAME} && echo ${DEV_USERNAME}:123456 | chpasswd \
	&& cat /tmp/bashrc >> ${DEV_HOME}/.bashrc \
	&& cat /tmp/vimrc >> ${DEV_HOME}/.vimrc \
	&& cp /tmp/gitconfig ${DEV_HOME}/.gitconfig \
	&& chown ${DEV_USERNAME}:${DEV_USERNAME} ${DEV_HOME}/.bashrc \
	&& chown ${DEV_USERNAME}:${DEV_USERNAME} ${DEV_HOME}/.vimrc \
	&& chown ${DEV_USERNAME}:${DEV_USERNAME} ${DEV_HOME}/.gitconfig

RUN apt install -y sudo \
	&& echo "${DEV_USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN apt install -y openjdk-8-jdk

COPY ./res/init.sh /init.sh

RUN echo "Installing golang.org..." \
	&& mkdir -p ${DEV_HOME}/src/golang.org/x \
	&& cd ${DEV_HOME}/src/golang.org/x/ \
	&& git clone https://github.com/golang/tools \
	&& git clone https://github.com/golang/sys \
	&& git clone https://github.com/golang/lint \
	&& git clone https://github.com/golang/net \
	&& git clone https://github.com/golang/crypto \
	&& chown ${DEV_USERNAME}:${DEV_USERNAME} -R ${DEV_HOME}/src/golang.org/

RUN apt install -y bash-completion

COPY ./res/molokai.vim /tmp/
RUN echo "Installing vim plugins..." \
	&& mkdir -p ${DEV_HOME}/.vim/bundle ${DEV_HOME}/.vim/colors \
	&& cp /tmp/molokai.vim ${DEV_HOME}/.vim/colors/ \
	&& git clone https://github.com/VundleVim/Vundle.vim.git ${DEV_HOME}/.vim/bundle/vundle \
	&& chown ${DEV_USERNAME}:${DEV_USERNAME} -R ${DEV_HOME}/.vim

RUN runuser -l ${DEV_USERNAME} -c 'vim +PluginInstall +q +q'
	
RUN chown ${DEV_USERNAME}:${DEV_USERNAME} -R ${DEV_HOME}/src

RUN apt install python-dev -y
RUN cd ${DEV_HOME}/.vim/bundle/YouCompleteMe \
	runuser -l ${DEV_USERNAME} -c '${DEV_HOME}/.vim/bundle/YouCompleteMe/install.sh'

RUN echo "Done!"

CMD /bin/bash /init.sh
