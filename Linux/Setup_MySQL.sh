#!/bin/bash
# The following script can be used to deploy a basic MySQL database server on Linux.
#
# The script uses docker and MariaDB.
#
# Consider adding IP security after completing this setup and verifying connectivity.

# Links:
# Docker - https://github.com/docker/docker-install
# MariaDB - https://hub.docker.com/_/mariadb
# DBeaver Database Client - https://dbeaver.io/

#apt install mysql-client-core-5.7		#Optionally install the MySQL Client on the host machine.
#apt install mariadb-client-core-10.1	#Optionally install the MySQL Client on the host machine.
#You can connect to your database with the following command-line: mysql -h localhost -p 3306 -u root

#Install Docker
sudo curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

#sudo docker stop mariadb	#Optionally stop any existing mariadb docker.
#sudo docker rm mariadb		#Optionally remove any existing mariadb docker.
#rm ~/mariadb -r			#Optionally delete any existing mariadb docker.

#Setup MySQL / MariaDB. Replace the variables in this line with appropriate values.
sudo docker run -d --name mariadb -v ~/mariadb:/var/lib/mysql -p 3306:3306 -e MYSQL_ALLOW_EMPTY_PASSWORD=no -e MYSQL_ROOT_PASSWORD="supersecretrootpasswordhere" -e MYSQL_DATABASE="databasenamehere" -e MYSQL_USER="databaseusernamehere" -e MYSQL_PASSWORD="supersecretdatabaseuserpasswordhere" --restart unless-stopped mariadb:latest

#sudo docker logs mariadb	#You can use this command to view the logs of the docker as it starts up.


