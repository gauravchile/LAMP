#!/bin/bash
# ============================================================
# Universal LAMP Installer (Apache, MariaDB, PHP)
# Works on: CentOS/RHEL (yum/dnf) & Ubuntu/Debian (apt)
# Author: Gaurav Chile
# ============================================================

set -e  # exit on errors

# ----------------------------
# Detect Package Manager
# ----------------------------
if command -v yum &>/dev/null; then
    PKG_MGR="yum"
    PHP_PKG="php php-mysqlnd php-pear"
    APACHE="httpd"
    DB_SRV="mariadb-server mariadb"
elif command -v dnf &>/dev/null; then
    PKG_MGR="dnf"
    PHP_PKG="php php-mysqlnd php-pear"
    APACHE="httpd"
    DB_SRV="mariadb-server mariadb"
elif command -v apt-get &>/dev/null; then
    PKG_MGR="apt-get"
    PHP_PKG="php libapache2-mod-php php-mysql"
    APACHE="apache2"
    DB_SRV="mariadb-server mariadb-client"
else
    echo "❌ Supported package manager not found (yum/dnf/apt-get)"
    exit 1
fi

echo "Detected package manager: $PKG_MGR"

# ----------------------------
# Install Apache
# ----------------------------
install_apache() {
    echo "=== Installing Apache ==="
    if ! command -v httpd &>/dev/null && ! command -v apache2 &>/dev/null; then
        sudo $PKG_MGR -y update &>/dev/null
        sudo $PKG_MGR -y install $APACHE &>/dev/null
    else
        echo "Apache already installed."
    fi
    sudo systemctl enable $APACHE &>/dev/null
    sudo systemctl start $APACHE &>/dev/null
    echo "✅ Apache started."
}

# ----------------------------
# Install MariaDB
# ----------------------------
install_mariadb() {
    echo "=== Installing MariaDB ==="
    if ! command -v mariadb &>/dev/null; then
        sudo $PKG_MGR -y install $DB_SRV &>/dev/null
    else
        echo "MariaDB already installed."
    fi
    sudo systemctl enable mariadb
    sudo systemctl start mariadb
    echo "✅ MariaDB started."

    read -p "Enter database name: " db_name
    read -p "Enter new DB username: " db_user
    read -s -p "Enter DB user password: " db_pass
    echo

    sudo mysql -u root <<MYSQL_SCRIPT
CREATE DATABASE IF NOT EXISTS $db_name;
CREATE USER IF NOT EXISTS '$db_user'@'localhost' IDENTIFIED BY '$db_pass';
GRANT ALL PRIVILEGES ON $db_name.* TO '$db_user'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT
    echo "✅ Database $db_name and user $db_user created."
}

# ----------------------------
# Install PHP
# ----------------------------
install_php() {
    echo "=== Installing PHP ==="
    if ! command -v php &>/dev/null; then
        sudo $PKG_MGR -y install $PHP_PKG &>/dev/null
    else
        echo "PHP already installed."
    fi
    echo "✅ PHP version: $(php -v | head -n 1)"

    # Create PHP test file
    sudo mkdir -p /var/www/html
    sudo tee /var/www/html/phptest.php > /dev/null <<EOF
<?php
phpinfo();
?>
EOF
    echo "✅ PHP test file created at /var/www/html/phptest.php"
}

# ----------------------------
# Run Installation
# ----------------------------
install_apache
install_mariadb
install_php

echo "================================================================="
echo " ✅ LAMP installation complete!"
echo " - Test Apache: http://<server-ip>/"
echo " - Test PHP:    http://<server-ip>/phptest.php"
echo "================================================================="
