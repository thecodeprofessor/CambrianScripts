#!/bin/bash
# The following script can be used to deploy a basic Moodle site.
#
# The script uses Bitnami's Docker Image of Moodle and MariaDB.
#
# Optionally add -p 3306:3306 to the docker run command for mariadb be able to connect to the mysql server from outside of the server. However, consider adding IP security after completing this setup and verifying connectivity.

# Links:
# Docker - https://github.com/docker/docker-install
# MariaDB - https://hub.docker.com/_/mariadb
# Bitnami - https://bitnami.com/stack/moodle/containers
# Bitnami HowTo - https://github.com/bitnami/bitnami-docker-moodle#how-to-use-this-image
# DBeaver Database Client - https://dbeaver.io/
#
# Consider adding IP security after completing this setup and verifying connectivity.

#apt install mysql-client-core-5.7		#Optionally install the MySQL Client on the host machine.
#apt install mariadb-client-core-10.1	#Optionally install the MySQL Client on the host machine.
#You can connect to your database with the following command-line: mysql -h localhost -p 3306 -u root

#Install Docker
sudo curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

#Create Docker Network
sudo docker network create moodle-tier

#sudo docker stop mariadb	#Optionally stop any existing mariadb docker.
#sudo docker rm mariadb		#Optionally remove any existing mariadb docker.
#rm ~/mariadb -r			#Optionally delete any existing mariadb docker.

#Setup MySQL / MariaDB. Replace the variables in this line with appropriate values.
sudo docker run -d --name mariadb -v ~/mariadb:/var/lib/mysql -e MYSQL_ALLOW_EMPTY_PASSWORD=no -e MYSQL_ROOT_PASSWORD="supersecretrootpasswordhere" -e MYSQL_DATABASE="moodle" -e MYSQL_USER="moodle" -e MYSQL_PASSWORD="supersecretdatabaseuserpasswordhere" --net moodle-tier --restart unless-stopped mariadb:latest

#sudo docker logs mariadb	#You can use this command to view the logs of the docker as it starts up.

#sudo docker stop moodle	#Optionally stop any existing moodle docker.
#sudo docker rm moodle		#Optionally remove any existing moodle docker.
#rm ~/moodle -r				#Optionally delete any existing moodle docker.

#Setup Moodle
docker run -d -p 80:80 -p 443:443 --name moodle -v ~/moodle:/bitnami -e MOODLE_USERNAME=cambrianadmin -e MOODLE_PASSWORD="supersecretmoodlepasswordhere" -e MOODLE_EMAIL="faculty.member@cambriancollege.ca" -e MARIADB_HOST="mariadb" -e MOODLE_DATABASE_NAME="moodle" -e MOODLE_DATABASE_USER="moodle" -e MOODLE_DATABASE_PASSWORD=supersecretdatabaseuserpasswordhere -e ALLOW_EMPTY_PASSWORD=no --net moodle-tier --restart unless-stopped bitnami/moodle:latest

#sudo docker logs moodle	#You can use this command to view the logs of the docker as it starts up.
