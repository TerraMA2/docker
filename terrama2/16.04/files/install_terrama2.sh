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
curl -O http://www.dpi.inpe.br/jenkins-data/terrama2/installers/linux/TerraMA2-4.0.0-linux-x64-Ubuntu-16.04.deb --silent

valid $? "Error: Could not fetch TerraMA²"

echo "Installing TerraMA² ... "
dpkg -i TerraMA2-4.0.0-linux-x64-Ubuntu-16.04.deb
rm TerraMA2-4.0.0-linux-x64-Ubuntu-16.04.deb

apt-get install -f -y
valid $? "Error: Could not install TerraMA²"

# No error
exit 0
