#!/bin/bash
set +x
set +e

sudo apt-get update -y
#http://askubuntu.com/questions/549550/installing-graphite-carbon-via-apt-unattended
sudo apt-get install -y apt-transport-https
sudo DEBIAN_FRONTEND=noninteractive apt-get -q -y --force-yes install graphite-carbon

#Install repo
sudo curl -s https://packagecloud.io/install/repositories/exoscale/community/script.deb.sh | sudo bash
sudo apt-get update -y

# P.135 - Listing 4.13: Installing the graphite-api package on Ubuntu
sudo apt-get install -y graphite-api

#Make and move to foulder for grafana install
mkdir /home/vagrant/grafanainstall
cd /home/vagrant/grafanainstall

#Download grafana
echo "downloading grafana"
wget https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana_4.2.0_amd64.deb

#install libfontconfig
sudo apt-get install -y adduser libfontconfig\

#Install grafana
sudo dpkg -i grafana_4.2.0_amd64.deb

#Move back to foulder
cd /home/vagrant/itmo453-553/graphite/graphitea/

# P.153 - Listing 4-39 - Create empty conf file to avoid error
sudo cp -v carbon.conf /etc/carbon
sudo touch /etc/carbon/storage-aggregation.conf

sudo cp -v storage-schemas.conf /etc/carbon

# Listing 4.44: Install the Carbon Cache init script on Ubuntu
sudo cp -v carbon-cache-ubuntu.init /etc/init.d/carbon-cache
sudo chmod 0755 /etc/init.d/carbon-cache

# Listing 4.45: Enable the Carbon Cache init script on Ubuntu
sudo update-rc.d carbon-cache defaults

# Listing 4.46: Install the Carbon relay init script on Ubuntu
sudo cp -v carbon-relay-ubuntu.init /etc/init.d/carbon-relay
sudo chmod 0755 /etc/init.d/carbon-relay 
sudo update-rc.d carbon-relay defaults

# Listing 4.49: Starting the Carbon daemons on Ubuntu
sudo cp graphite-carbon /etc/default/graphite-carbon
sudo service carbon-relay start 
sudo service carbon-cache start

# P. 162 Copy the default graphite-api.yaml file overwritting the default one installed
sudo cp -v graphite-api.yaml /etc/graphite-api.yaml

# Listing 4.56: Creating the /var/lib/graphite/api_search_index file
sudo touch /var/lib/graphite/api_search_index
sudo chown _graphite:_graphite /var/lib/graphite/api_search_index

# Listing 4.57: Restarting the Graphite-API on Ubuntu
sudo service graphite-api start

# Listing 4.61: Starting the Grafana Server
sudo service grafana-server start



