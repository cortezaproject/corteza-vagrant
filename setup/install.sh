#!/bin/bash

set -eu

export LC_ALL="en_US.UTF-8"

# Tweaking APT for headless install
export DEBIAN_FRONTEND="noninteractive"

# Node.js Ubuntu package repository
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -

# Percona pre-install steps
wget --quiet https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb
dpkg -i percona-release_latest.$(lsb_release -sc)_all.deb
rm percona-release_latest.$(lsb_release -sc)_all.deb
percona-release setup ps80

# Install all ubuntu packages
apt-get update -qq
apt-get -y -q \
    install \
    --no-install-recommends \
    -o Dpkg::Options::="--force-confdef" \
    -o Dpkg::Options::="--force-confnew" \
      git \
      build-essential  \
      apt-transport-https \
      curl \
      ca-certificates \
      nginx \
      supervisor \
      percona-server-server \
      nodejs

# Percona db seeding
mysql < /vagrant/setup/percona-db.sql

# NginX config
rm /etc/nginx/sites-enabled/default
ln -s /vagrant/setup/nginx-site.conf /etc/nginx/sites-enabled/default
service nginx reload

# Mailhog smtp server & mail webapp
wget --quiet https://github.com/mailhog/MailHog/releases/download/v1.0.0/MailHog_linux_amd64
mv MailHog_linux_amd64 /usr/local/bin/mailhog

# Install (non-dev) Corteza servers & webapps
#
# This is done before supervisor configuration just to be sure that everything is in place
# before API and Corredor servers starts
make -C /vagrant -j4 dist

# Supervisor config
#
# It starts and monitors API, Corredor and Mailhog services.
ln -s /vagrant/setup/supervisor-api.conf /etc/supervisor/conf.d/corteza-server-api.conf
ln -s /vagrant/setup/supervisor-corredor.conf /etc/supervisor/conf.d/corteza-server-corredor.conf
ln -s /vagrant/setup/supervisor-mailhog.conf /etc/supervisor/conf.d/mailhog.conf
service supervisor restart

#
