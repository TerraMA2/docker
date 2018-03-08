FROM ubuntu:16.04

############################################################################
# Information
LABEL maintainer="TerraMA² Team <terrama2-team@dpi.inpe.br>" \
      version="4.0.0"

############################################################################
# Environment Variables
ENV BDQLIGHT_INSTALL_PATH=/opt/bdqueimadas-light

############################################################################
# Dependencies

RUN apt-get update && \
    apt-get install -y curl \
                       git \
                       unzip \
                       sudo \
                       openssh-server \
                       gdal-bin

# NodeJS
RUN curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - && \
    apt-get install -y nodejs

#Grunt
RUN npm install -g grunt-cli

############################################################################
# BDQueimadas Light

COPY files/install_bdqlight.sh .

RUN ./install_bdqlight.sh && rm install_bdqlight.sh

WORKDIR ${BDQLIGHT_INSTALL_PATH}

EXPOSE 39000

COPY docker-entrypoint.sh /

ENTRYPOINT /docker-entrypoint.sh