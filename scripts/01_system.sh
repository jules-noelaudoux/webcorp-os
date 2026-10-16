#!/usr/bin bash

sudo apt update

# apache
sudo apt install apache2 libapache2-mpm-itk

# mariadb
sudo apt install mariadb-server mariadb-client
sudo mariadb-secure-installation

# php
sudo apt install libapache2-mod-php php-mysql

#installation de restic
sudo apt-get install -y restic
restic version
