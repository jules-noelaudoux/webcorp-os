#!/bin/bash

set -e

export DEBIAN_FRONTEND=noninteractive

# installation de Kodi
sudo apt install software-properties-common
sudo add-apt-repository -y ppa:team-xbmc/ppa
sudo apt install kodi -y
