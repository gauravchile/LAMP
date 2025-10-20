#!/bin/bash
# ============================================================
# Universal LAMP Installer (Apache, MariaDB, PHP)
# Works on: CentOS/RHEL (yum/dnf) & Ubuntu/Debian (apt)
# Author: Gaurav Chile
# ============================================================

set -euo pipefail

IP=$(ifconfig | awk '/inet/ {print $2}' | head -1)

# ----------------------------
# Spinner + percentage function
# ----------------------------
show_progress() {
    local msg=$1
    local duration=${2:-3}
    local frames=(⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏)
    local end_time=$((SECONDS + duration))
    local progress=0
    while [ $SECONDS -lt $end_time ]; do
        for f in "${frames[@]}"; do
            printf "\r%s  %s... %d%%" "$f" "$msg" "$progress"
            sleep 0.1
            progress=$((progress + RANDOM % 5))
            [ $progress -ge 99 ] && progress=99
        done
    done
    printf "\r✅  %s... 100%%\n" "$msg"
}

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
    show_progress "Installing Apache" 5
    if ! command -v httpd &>/dev/null && ! command -v apache2 &>/dev/null; then
        sudo $PKG_MGR -y update &>/dev/null
        sudo $PKG_MGR -y install $APACHE &>/dev/null
    fi
    sudo systemctl enable $APACHE &>/dev/null
    sudo systemctl start $APACHE &>/dev/null
    echo "✅ Apache started."
}

# ----------------------------
# Install MariaDB
# ----------------------------
install_mariadb() {
    show_progress "Installing MariaDB" 5
    if ! command -v mariadb &>/dev/null; then
        sudo $PKG_MGR -y install $DB_SRV &>/dev/null
    fi
    sudo systemctl enable mariadb &>/dev/null
    sudo systemctl start mariadb &>/dev/null
    echo "✅ MariaDB started."

    read -p "Enter database name: " db_name
    read -p "Enter new DB username: " db_user
    read -s -p "Enter DB user password: " db_pass
    echo

    show_progress "Creating database and user" 3
    sudo mysql -u root <<MYSQL_SCRIPT
CREATE DATABASE IF NOT EXISTS $db_name;
CREATE USER IF NOT EXISTS '$db_user'@'localhost' IDENTIFIED BY '$db_pass';
GRANT ALL PRIVILEGES ON $db_name.* TO '$db_user'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT
    echo "✅ Database '$db_name' and user '$db_user' created."
}

# ----------------------------
# Install PHP
# ----------------------------
install_php() {
    show_progress "Installing PHP" 4
    if ! command -v php &>/dev/null; then
        sudo $PKG_MGR -y install $PHP_PKG &>/dev/null
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
echo " - Test Apache: http://$IP/"
echo " - Test PHP:    http://$IP/phptest.php"
echo "================================================================="
