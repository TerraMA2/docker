#!/bin/bash

function valid()
{
  if [ $1 -ne 0 ]; then
    echo "$2"
    exit $1
  else
    echo "done"
  fi
}

apt-get update

# TODO: Change URL to http://www.dpi.inpe.br/terrama2/doku.php?id=download and change curl parameter to -o deb_package_name
echo -ne "Downloading TerraMA² ... "
curl -O http://www.dpi.inpe.br/jenkins-data/terrama2/installers/linux/TerraMA2-${TERRAMA2_TAG}-release-linux-x64-Ubuntu-16.04.deb --silent
valid $? "Error: Could not fetch TerraMA²"

echo -ne "Downloading TerraMA² documentation ..."
curl -O http://www.dpi.inpe.br/jenkins-data/terrama2/installers/linux/terrama2-doc-${TERRAMA2_TAG}.deb --silent
valid $? "Error: Could not fetch TerraMA² documentation module"

echo "Installing TerraMA² ... "
dpkg -i TerraMA2-${TERRAMA2_TAG}-release-linux-x64-Ubuntu-16.04.deb
rm TerraMA2-${TERRAMA2_TAG}-release-linux-x64-Ubuntu-16.04.deb

apt-get install -f -y
valid $? "Error: Could not install TerraMA²"

dpkg -i terrama2-doc-${TERRAMA2_TAG}.deb
rm terrama2-doc-${TERRAMA2_TAG}.deb
apt-get install -f -y

if [ $? -ne 0 ]; then
  echo "Warning: Could not install TerraMA² Documentation Module"
fi

echo -ne "Configuring permission on /opt to terrama2..."
chown -R terrama2:terrama2 /opt/terrama2/${TERRAMA2_TAG}
valid $? "Could not set permission on directory /opt"

rm -rf /var/lib/apt/lists/*

# No error
exit 0
