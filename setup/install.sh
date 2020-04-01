#!/bin/bash

set -eu

export DEBIAN_FRONTEND=noninteractive

apt-get update -qq
apt-get -y -q \
  -o Dpkg::Options::="--force-confdef" \
  -o Dpkg::Options::="--force-confnew" \
  install \
    --no-install-recommends \
      git \
      build-essential  \
      apt-transport-https \
      curl \
      ca-certificates \
      gnupg2 \
      apt-utils \
      percona-server-server \
      nodejs

wget --quiet https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb
dpkg -i percona-release_latest.$(lsb_release -sc)_all.deb
percona-release setup ps80
mysql < /vagrant/setup/percona-db.sql

#
