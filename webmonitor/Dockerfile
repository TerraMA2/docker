FROM terrama2.dpi.inpe.br:443/terrama2:4.0.0

EXPOSE 36001

RUN rm /home/$TERRAMA2_USER/.ssh/authorized_keys

COPY docker-entrypoint.sh /

ENTRYPOINT /docker-entrypoint.sh
