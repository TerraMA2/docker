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

# TODO: Change URL to http://www.dpi.inpe.br/terrama2/doku.php?id=download and change curl parameter to -o deb_package_name
echo -ne "Downloading TerraMA² ... "
curl -O http://www.dpi.inpe.br/jenkins-data/terrama2/installers/linux/TerraMA2-4.0.1-alpha1-linux-x64-Ubuntu-16.04.deb --silent
valid $? "Error: Could not fetch TerraMA²"

echo -ne "Downloading TerraMA² documentation ..."
curl -O http://www.dpi.inpe.br/jenkins-data/terrama2/installers/linux/terrama2-doc.deb --silent
valid $? "Error: Could not fetch TerraMA² documentation module" 

echo "Installing TerraMA² ... "
dpkg -i TerraMA2-4.0.1-alpha1-linux-x64-Ubuntu-16.04.deb
rm TerraMA2-4.0.1-alpha1-linux-x64-Ubuntu-16.04.deb

apt-get install -f -y
valid $? "Error: Could not install TerraMA²"

dpkg -i terrama2-doc.deb
rm terrama2-doc.deb
apt-get install -f -y

if [ $? -ne 0 ]; then
  echo "Warning: Could not install TerraMA² Documentation Module"
fi

# No error
exit 0
