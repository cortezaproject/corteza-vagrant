#!/bin/bash
# This is the entry point for configuring the system.
#####################################################

#install basic tools
sudo DEBIAN_FRONTEND=noninteractive apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew" install git
echo "127.0.0.1    db" | sudo tee -a /etc/hosts

# Setup the base OS
sudo DEBIAN_FRONTEND=noninteractive apt-get update -qq \
 && sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends build-essential  \
    apt-transport-https curl ca-certificates gnupg2 apt-utils nodejs

# Install percona 8
wget https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb
sudo DEBIAN_FRONTEND=noninteractive dpkg -i percona-release_latest.$(lsb_release -sc)_all.deb
sudo percona-release setup ps80
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y percona-server-server
sudo mysql < /home/vagrant/workspace/src/percona-db.sql

# Install node from nodesource
# uncomment the next 2 lines for fix
curl -sL https://deb.nodesource.com/setup_10.x | sudo DEBIAN_FRONTEND=noninteractive bash - \
  && sudo DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs

# Install yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo DEBIAN_FRONTEND=noninteractive apt-key add - \
 && echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list \
 && sudo DEBIAN_FRONTEND=noninteractive apt-get update -qq \
 && sudo DEBIAN_FRONTEND=noninteractive apt-get install -y yarn

#get golang
curl -O https://dl.google.com/go/go1.12.17.linux-amd64.tar.gz

#unzip the archive 
tar -xvf go1.12.17.linux-amd64.tar.gz

#move the go lib to local folder
mv go /usr/local

#delete the source file
rm  go1.12.17.linux-amd64.tar.gz

#only full path will work
touch /home/vagrant/.bash_profile

echo "export PATH=$PATH:/usr/local/go/bin" >> /home/vagrant/.bash_profile

echo `export GOPATH=/home/vagrant/workspace:$PATH` >> /home/vagrant/.bash_profile

export GOPATH=/home/vagrant/workspace

mkdir -p "$GOPATH/bin" 

## INSTALL Vue for corteza-webapp-one
yarn global add @vue/cli
yarn install