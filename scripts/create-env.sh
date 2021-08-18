#!/bin/bash

echo "********************"
echo "* Create .env file *"
echo "********************"
echo ""

CURRENT_FOLDER=$(basename $(pwd))
if [ "$CURRENT_FOLDER" == 'scripts' ] ; then
  cd ..
fi

if [ ! -e ".env" ]
then
      cp .env.example .env
fi

TERRAMA2_TAG=$1
COMPOSE_PROJECT_NAME=$2

sed -i "/TERRAMA2_TAG/cTERRAMA2_TAG=${TERRAMA2_TAG}" .env
sed -i "/COMPOSE_PROJECT_NAME/cCOMPOSE_PROJECT_NAME=${COMPOSE_PROJECT_NAME}" .env
sed -i "/BACKUP_DIR/cBACKUP_DIR=/data/backup/${COMPOSE_PROJECT_NAME}" .env
