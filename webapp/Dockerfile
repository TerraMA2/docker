FROM terrama2.dpi.inpe.br:443/terrama2:4.0.0

EXPOSE 36000

COPY docker-entrypoint.sh /

WORKDIR ${TERRAMA2_INSTALL_PATH}/webapp

ENTRYPOINT /docker-entrypoint.sh
