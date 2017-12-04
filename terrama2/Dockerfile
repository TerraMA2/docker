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
ENV TERRAMA2_CODEBASE_PATH=${DEV_DIR}/terrama2/codebase
ENV TERRAMA2_3RDPARTY_PATH=${DEV_DIR}/terrama2/3rdparty
ENV PATH="$PATH:${TERRAMA2_INSTALL_PATH}/bin"

RUN apt-get update && \
    apt-get install -y cmake \
                       curl \
                       software-properties-common \
                       libquazip-dev \
                       git \
                       unzip \
                       sudo \
                       screen \
                       openssh-server \
                       # VMime Dependencies
                       doxygen \
                       # Process Control
                       supervisor

# Creating USER
RUN groupadd $TERRAMA2_USER && \
    useradd $TERRAMA2_USER -s /bin/bash -m -g $TERRAMA2_USER && \
    # Defining User credential to connect
    echo $TERRAMA2_USER:$TERRAMA2_USER | chpasswd && \
    mkdir -p $TERRAMA2_3RDPARTY_PATH $TERRAMA2_CODEBASE_PATH && \
    chown -R $TERRAMA2_USER:$TERRAMA2_USER /home/$TERRAMA2_USER && \
    chmod g-w /home/$TERRAMA2_USER

############################################################################
# Dependencies

# TerraLib
RUN cd ${TERRAMA2_3RDPARTY_PATH} && \
    curl -o terralib-5.2.4-ubuntu-16.04.tar.gz -L http://www.dpi.inpe.br/terralib5/download/download.php?FileName=terralib-5.2.4-ubuntu-16.04.tar.gz && \
    tar zxf terralib-5.2.4-ubuntu-16.04.tar.gz && \
    ./install.sh && \
    rm -rf *

# NodeJS
RUN curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - && \
    apt-get install -y nodejs

# VMime
RUN cd ${TERRAMA2_CODEBASE_PATH} && \
    curl -O http://www.dpi.inpe.br/jenkins-data/terrama2/3rdparty/terrama2-vmime_0.9.2-ubuntu-16.04_amd64.deb && \
    apt-get install -y libgsasl7 && \
    dpkg -i terrama2-vmime_0.9.2-ubuntu-16.04_amd64.deb && \
    apt-get install -f -y && \
    rm -rf terrama2-vmime_0.9.2-ubuntu-16.04_amd64.deb* v* ${TERRAMA2_CODEBASE_PATH}

# ############################################################################
# # TerraMA2
COPY files/install_terrama2.sh .

RUN ./install_terrama2.sh

COPY files/start_terrama2_service.sh /usr/local/bin

WORKDIR ${TERRAMA2_INSTALL_PATH}