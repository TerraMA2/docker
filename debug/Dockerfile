FROM ubuntu:16.04

############################################################################
# Information
LABEL maintainer="TerraMA² Team <terrama2-team@dpi.inpe.br>" \
      version="4.0.0"

############################################################################
# Environment Variables
ENV TERRAMA2_USER=terrama2
ENV DEV_DIR=/home/${TERRAMA2_USER}/mydevel
ENV TERRAMA2_INSTALL_PATH=/opt/terrama2/4.0.0
ENV TERRAMA2_BUILD_PATH=/opt/terrama2/build
ENV TERRAMA2_CODEBASE_PATH=/opt/terrama2/codebase
ENV TERRAMA2_3RDPARTY_PATH=${DEV_DIR}/terrama2/3rdparty
ENV PATH="$PATH:${TERRAMA2_INSTALL_PATH}/bin"

RUN apt-get update && \
    apt-get install -y cmake \
                       build-essential \
                       curl \
                       libquazip-dev \
                       git \
                       unzip \
                       sudo \
                       screen \
                       openssh-server \
                       # VMime Dependencies
                       doxygen \
                       # Locales
                       locales \
                       # Devel
                       qtcreator \
                       libcurl3-dev \
                       libpython2.7-dev \
                       libproj-dev \
                       libgeos++-dev \
                       libxerces-c-dev \
                       # VNC
                       x11vnc \
                       xvfb \
                       xterm \
                       fluxbox

# Creating USER
RUN groupadd $TERRAMA2_USER && \
    useradd $TERRAMA2_USER -s /bin/bash -m -g $TERRAMA2_USER && \
    # Defining User credential to connect
    echo $TERRAMA2_USER:$TERRAMA2_USER | chpasswd && \
    mkdir -p $TERRAMA2_3RDPARTY_PATH $TERRAMA2_CODEBASE_PATH && \
    chmod g-w /home/$TERRAMA2_USER && \
    chown -R $TERRAMA2_USER:$TERRAMA2_USER /home/$TERRAMA2_USER

############################################################################
# Dependencies

# TerraLib
RUN cd ${TERRAMA2_3RDPARTY_PATH} && \
    curl -o terralib-5.2.4-ubuntu-16.04.tar.gz -L http://www.dpi.inpe.br/terralib5/download/download.php?FileName=terralib-5.2.4-ubuntu-16.04.tar.gz && \
    tar zxf terralib-5.2.4-ubuntu-16.04.tar.gz && \
    ./install.sh && \
    rm -rf *

# VMime
RUN cd ${TERRAMA2_CODEBASE_PATH} && \
    curl -O http://www.dpi.inpe.br/jenkins-data/terrama2/3rdparty/terrama2-vmime_0.9.2-ubuntu-16.04_amd64.deb && \
    apt-get install -y libgsasl7 && \
    dpkg -i terrama2-vmime_0.9.2-ubuntu-16.04_amd64.deb && \
    apt-get install -f -y && \
    rm -rf terrama2-vmime_0.9.2-ubuntu-16.04_amd64.deb* v*

############################################################################
# TerraMA2
RUN mkdir -p /data && chown -R ${TERRAMA2_USER}:${TERRAMA2_USER} /data

RUN git clone https://github.com/terrama2/terrama2.git ${TERRAMA2_CODEBASE_PATH}

RUN mkdir -p ${TERRAMA2_BUILD_PATH} && \
    cd ${TERRAMA2_BUILD_PATH} && \
    cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE="Debug" \
                              -DCMAKE_PREFIX_PATH="/opt/terralib/5.2.4;/opt/terralib/5.2.4/3rdparty;/opt/terrama2/4.0.0/3rdparty" \
                              -DCMAKE_INSTALL_PREFIX="${TERRAMA2_INSTALL_PATH}" \
                              -DTERRAMA2_BUILD_UNITTEST_ENABLED=OFF \
                              -DTERRAMA2_UNITTEST_CORE_ENABLED=OFF \
                              -DTERRAMA2_UNITTEST_COLLECTOR_ENABLED=OFF \
                              -DTERRAMA2_UNITTEST_ANALYSIS_ENABLED=OFF \
                              ${TERRAMA2_CODEBASE_PATH}/build/cmake && \
    make -j8

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

RUN echo "export LANG=en_US.UTF-8\n\
export LANGUAGE=en_US.UTF-8\n\
export LC_CTYPE=\"en_US.UTF-8\"\n\
export LC_NUMERIC=\"en_US.UTF-8\"\n\
export LC_TIME=\"en_US.UTF-8\"\n\
export LC_COLLATE=\"en_US.UTF-8\"\n\
export LC_MONETARY=\"en_US.UTF-8\"\n\
export LC_MESSAGES=\"en_US.UTF-8\"\n\
export LC_PAPER=\"en_US.UTF-8\"\n\
export LC_NAME=\"en_US.UTF-8\"\n\
export LC_ADDRESS=\"en_US.UTF-8\"\n\
export LC_TELEPHONE=\"en_US.UTF-8\"\n\
export LC_MEASUREMENT=\"en_US.UTF-8\"\n\
export LC_IDENTIFICATION=\"en_US.UTF-8\"\n\
export LC_ALL=en_US.UTF-8" | tee -a /etc/bash.bashrc

VOLUME /data

WORKDIR "/opt"

COPY docker-entrypoint.sh /

ENTRYPOINT [ "/docker-entrypoint.sh" ]