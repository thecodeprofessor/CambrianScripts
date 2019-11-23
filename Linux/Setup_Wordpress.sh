#!/bin/bash
# The following script can be used to deploy a basic Wordpress website on Linux.
#
# The script uses docker, MariaDB, and Wordpress.
#
# Consider adding IP security after completing this setup and verifying connectivity.

# Links:
# Docker - https://github.com/docker/docker-install
# MariaDB - https://hub.docker.com/_/mariadb
# Wordpress - https://docs.docker.com/compose/wordpress/

#Install Docker
sudo curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

#Create directories to store the website components.
#sudo rm -r ~/mywebsite		#Optionally delete the existing directory.

sudo mkdir ~/mywebsite
sudo mkdir ~/mywebsite/server
sudo mkdir ~/mywebsite/server/apache2
sudo mkdir ~/mywebsite/server/www

#Create a network to allow the database and webserver to communicate with eachother.
sudo docker network create --driver bridge mywebsite

#sudo docker stop mywebsite-database	#Optionally stop any existing mariadb docker.
#sudo docker rm mywebsite-database		#Optionally remove any existing mariadb docker.

#sudo docker stop mywebsite				#Optionally stop any existing mariadb docker.
#sudo docker rm mywebsite				#Optionally remove any existing mariadb docker.

#Setup MySQL / MariaDB. Replace the variables in this line with appropriate values.
sudo docker run -d --name mywebsite-database --network="mywebsite" -v ~/mywebsite/database/mysql:/var/lib/mysql -p 3306:3306 -e MYSQL_ALLOW_EMPTY_PASSWORD=no -e MYSQL_ROOT_PASSWORD="passwordhere" -e MYSQL_DATABASE="databasenamehere" -e MYSQL_USER="usernamehere" -e MYSQL_PASSWORD="passwordhere" --restart unless-stopped mariadb:latest --default_authentication_plugin=mysql_native_password

#Setup and then remove a temporary docker using the Wordpress image that can be used to copy the default apache configuration files as well as other default files to a local directory.
#These files will be used by your website and will be stored in a convenient location so you can edit them.
sudo docker run -d --name mywebsite-temp wordpress:latest
sudo docker cp mywebsite-temp:/etc/apache2 ~/mywebsite/server
sudo docker cp mywebsite-temp:/var/www ~/mywebsite/server
sudo docker stop mywebsite-temp
sudo docker rm mywebsite-temp

#Setup Apache/Wordpress. Replace the variables in this line with appropriate values.
sudo docker run -d --name mywebsite --network="mywebsite" -v ~/mywebsite/server/apache2:/etc/apache2 -v ~/mywebsite/server/www:/var/www -p 80:80 -p 443:443 -e WORDPRESS_DB_HOST="mywebsite-database:3306" -e WORDPRESS_DB_NAME="databasenamehere" -e WORDPRESS_DB_USER="usernamehere" -e WORDPRESS_DB_PASSWORD="passwordhere" --restart unless-stopped wordpress:latest

#List docker containers.
sudo docker ps

#View the web server docker container logs.
sudo docker logs mywebsite

#Visit the following address in your web browser: http://ipaddress/wp-admin/install.php
