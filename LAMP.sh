#!/bin/bash

#############################
#Author: Blessing Ogbeh
#Date: 07/07/2024

#Version: V1
# This Script implements the LAMP stack on Linux Ubuntu 24.04 
################################################################



###################################################
# Installing Apache on the Server


set - x

echo "updating the server"

sudo apt update

echo "Installing Apache2"

sudo apt install apache2 -y

sudo systemctl status apache2

# verify we have traffic, request the apache http server on port 80
curl http://localhost:80


############################################
# Installing MySql on the virtual Server

echo "installing MySql"

sudo apt install mysql-server -y

echo secure mysql server

sudo mysql_secure_installation

# to verify mysql is working

#sudo mysql  #type 'exit' to exit the mysql console


##############################
# Installing PHP on the server

echo "installing php and the required modules for communication with apache and mysql"

sudo apt install php libapache2-mod-php php-mysql -y

echo "GREAT! LAMP STACK IS NOW COMPLETELY INSTALLED AND FULLY OPERATIONAL"


########################################
# Creating a Virtual Host Using Apache

#Create a Directory for Your Site:
sudo mkdir -p /var/www/project-lamp
sudo chown -R $USER:$USER /var/www/project-lamp  # Assigning ownership to the directory
sudo chmod -R 755 /var/www/project-lamp  # Granting appropriate permissions for user, group and others

# Create a Sample HTML File in the directory of the site
vim /var/www/project-lamp/index.html
 #in it add the following
    <html>
    <head>
        <title>Welcome to PROJECT LAMP!</title>
    </head>
    <body>
        <h1>Success! Your Virtual Host is working!</h1>
    </body>
    </html>


# Create a New Virtual Host Configuration File:
sudo vim /etc/apache2/sites-available/project-lamp.conf
 #in it paste the following
    <VirtualHost *:80>
    ServerAdmin webmaster@project-lamp
    ServerName project-lamp
    ServerAlias www.project-lamp
    DocumentRoot /var/www/project-lamp
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
    <Directory /var/www/project-lamp>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    </VirtualHost>

sudo ls /etc/apache2/sites-available  # to show the new file in the sites-available directory

sudo a2ensite project-lamp.conf      # Enable the New Virtual Host:

sudo a2dissite 000-default.conf      #Disable the Default Virtual Host (optional but recommended for a clean setup)

sudo apache2ctl configtest    ## to make sure our configuration doesnt contain any errors

sudo systemctl reload apache2  # restart Apache so changes can take effect

# Enable PHP on the website
sudo vim /etc/apache2/mods-enabled/dir.conf 
 # in it paste ths:
 <IfModule mod_dir.c>
    DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm
</IfModule>

sudo vim /var/www/project-lamp/index.php  #Create a PHP info file to verify that PHP is working correctly.
 # in it paste this
 <?php
phpinfo();
?>

# Restart Apache to apply the changes:
sudo systemctl restart apache2

sudo rm /var/www/project-lamp/index.php

echo "LAMP stack installed and virtual hosting set up for your_domain [Project LAMP]"