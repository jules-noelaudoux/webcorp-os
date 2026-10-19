#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive

echo "--- 1. Installation du système et de la pile LAMP ---"

apt-get update

# Outils de base utiles
apt-get install -y curl wget git unzip xmlstarlet software-properties-common ca-certificates ssl-cert

# Apache et MPM-ITK
apt-get install -y apache2 libapache2-mpm-itk
a2enmod ssl rewrite mpm_itk || true
a2ensite default-ssl || true

# MariaDB
apt-get install -y mariadb-server mariadb-client

# Sécurisation MariaDB et création de l'administrateur local
service mariadb start || true
mariadb -e "DELETE FROM mysql.user WHERE User='';" 2>/dev/null || true
mariadb -e "DROP DATABASE IF EXISTS test;" 2>/dev/null || true
mariadb -e "CREATE USER IF NOT EXISTS 'admin_local'@'localhost' IDENTIFIED BY 'temp';" 2>/dev/null || true
mariadb -e "GRANT ALL PRIVILEGES ON *.* TO 'admin_local'@'localhost' WITH GRANT OPTION;" 2>/dev/null || true
mariadb -e "FLUSH PRIVILEGES;" 2>/dev/null || true

# PHP et extensions
apt-get install -y php php-cli libapache2-mod-php php-mysql php-curl php-gd php-mbstring php-xml php-zip php-intl

# Outil de sauvegarde
apt-get install -y restic

echo "Fin de l'étape 1."
