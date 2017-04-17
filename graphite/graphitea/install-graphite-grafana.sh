#!/bin/bash
set +x
set +e

sudo apt-get update -y
#http://askubuntu.com/questions/549550/installing-graphite-carbon-via-apt-unattended
sudo apt-get install -y apt-transport-https
sudo DEBIAN_FRONTEND=noninteractive apt-get -q -y --force-yes install graphite-carbon

#Install repo
curl -s https://packagecloud.io/install/repositories/exoscale/community/script.deb.sh | sudo bash
sudo apt-get update -y

# P.135 - Listing 4.13: Installing the graphite-api package on Ubuntu
sudo apt-get install -y graphite-api

Adding the Grafana repository
curl -s https://packagecloud.io/install/repositories/grafana/stable/script.deb.sh | sudo bash

# P.137 - Listing 4.18: Installing the Grafana package
sudo apt-get update -y
sudo apt-get install -y grafana

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



