#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive

echo "--- 1. Installation du système et de la pile LAMP ---"

apt-get update

# Mise a jour obligatoire suite a la CVE de PHP
apt upgrade -y

# Paquets de base, pile LAMP et outils
apt-get install -y \
    curl wget git unzip xmlstarlet software-properties-common ca-certificates ssl-cert \
    apache2 libapache2-mpm-itk \
    mariadb-server mariadb-client \
    php php-cli libapache2-mod-php php-mysql php-curl php-gd php-mbstring php-xml php-zip php-intl \
    restic

# Configuration Apache
a2enmod ssl rewrite mpm_itk
a2ensite default-ssl

# Initialisation MariaDB et création de l'administrateur local
service mariadb start
mariadb -e "CREATE USER IF NOT EXISTS 'admin_local'@'localhost' IDENTIFIED BY 'temp';"
mariadb -e "GRANT ALL PRIVILEGES ON *.* TO 'admin_local'@'localhost' WITH GRANT OPTION;"
mariadb -e "FLUSH PRIVILEGES;"

echo "Étape 1 terminée."
