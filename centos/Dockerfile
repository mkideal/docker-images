#
# 构建用于上线运行的服务器程序的编译和运行环境
#

FROM centos:7.9.2009

COPY ../res/Centos-7.repo /etc/yum.repos.d/
RUN yum --enablerepo=* clean all
RUN yum update -y
RUN yum install -y tar gzip gcc-c++ glibc-devel
RUN yum install -y git

ENV LD_LIBRARY_PATH /usr/local/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

RUN yum install -y which
RUN yum install -y openssh-clients
RUN yum install -y openssh-server
RUN yum install -y wget
RUN yum install -y epel-release
RUN yum install -y sudo
RUN yum install -y vim
RUN yum install -y autoconf
RUN yum install -y automake
RUN yum install -y libtool
RUN yum install -y lz4 lz4-devel
RUN yum install -y java
RUN yum install -y pwgen
RUN yum -y install yum-utils
RUN yum install ntp -y
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && ssh-keygen -f /etc/ssh/ssh_host_rsa_key \
    && ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key \
	&& chmod 600 /etc/ssh/ssh_host* \
    && echo 'root:123456' | chpasswd

RUN sed -i '/pam_loginuid.so/c session    optional     pam_loginuid.so'  /etc/pam.d/sshd

RUN yum install -y gcc
RUN yum install -y make

# Install cmake
ENV CMAKE_VERSION=3.9.1
RUN echo "Installing cmake${CMAKE_VERSION}..." \
	&& cd /tmp/ \
	&& wget https://cmake.org/files/v3.9/cmake-${CMAKE_VERSION}.tar.gz \
	&& tar zxf cmake-${CMAKE_VERSION}.tar.gz \
	&& cd cmake-${CMAKE_VERSION} \
	&& ./configure && make && make install \
	&& cd .. \
	&& rm -rf cmake-${CMAKE_VERSION}*

# Install gcc-11
ENV GCC_VERSION=11.2.0
RUN echo "Installing gcc${GCC_VERSION}"
RUN mkdir /tmp/gcc && \
    cd /tmp/gcc && \
    curl http://mirrors.concertpass.com/gcc/releases/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.gz | tar -zxf -
RUN yum install -y bzip2
ENV BINUTILSVER=2.39
RUN wget http://ftp.gnu.org/gnu/binutils/binutils-$BINUTILSVER.tar.gz
RUN tar zxf binutils-$BINUTILSVER.tar.gz
RUN cd /tmp/gcc/gcc-${GCC_VERSION} && \
    for i in bfd binutils cpu elfcpp etc gas gold gprof ld opcodes texinfo; \
        do ln -s /tmp/gcc/binutils-$BINUTILSVER/$i; done && \
    sed -i 's/wget/curl -O/g' contrib/download_prerequisites && \
    contrib/download_prerequisites && \
    mkdir /tmp/gcc/build && \
    cd /tmp/gcc/build && \
    ../gcc-${GCC_VERSION}/configure --disable-multilib --enable-languages=c,c++,fortran
RUN cd /tmp/gcc/build && make -j `nproc` && make install

RUN yum erase -y gcc-c++ --setopt=clean_requirements_on_remove=1 \
RUN yum clean all \
    rm -rf /tmp/gcc

# Create user
ENV DEV_USERNAME=dev
ENV DEV_HOME=/home/dev

COPY ../res/bashrc /tmp/
COPY ../res/gitconfig /tmp/gitconfig

RUN useradd -ms /bin/bash ${DEV_USERNAME} && echo ${DEV_USERNAME}:123456 | chpasswd \
	&& cat /tmp/bashrc >> ${DEV_HOME}/.bashrc \
	&& cp /tmp/gitconfig ${DEV_HOME}/.gitconfig \
	&& chown ${DEV_USERNAME}:${DEV_USERNAME} ${DEV_HOME}/.bashrc \
	&& chown ${DEV_USERNAME}:${DEV_USERNAME} ${DEV_HOME}/.gitconfig

RUN rm -f /usr/lib64/libstdc++.so.6 \
	&& cp /usr/local/lib64/libstdc++.so.6 /usr/lib64/libstdc++.so.6

RUN echo 'dev ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

CMD /bin/bash /init.
