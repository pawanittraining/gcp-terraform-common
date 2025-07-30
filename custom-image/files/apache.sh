#!/bin/bash

# Update package list and install Apache & Git
apt update
apt install -y apache2 git

# Enable and start Apache
systemctl enable apache2
systemctl start apache2

# Clear the default web root (optional)
rm -rf /var/www/html/*

# Clone the latest code from GitHub
git clone https://github.com/pawanittraining/sample-website.git /var/www/html/

# Set correct permissions
chown -R www-data:www-data /var/www/html
