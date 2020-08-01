FROM node:12

WORKDIR /app

RUN apt-get update && \
    apt-get install -y gdal-bin zip && \
    git clone -b b1.0.0 -o upstream https://github.com/TerraMA2/terrama2-report-server.git . && \
    npm install --production

ENV NODE_ENV=production

EXPOSE 3200

ENTRYPOINT ["npm", "run", "prod"]
