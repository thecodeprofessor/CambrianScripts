#!/bin/bash
# The following script can be used to deploy a basic Wordpress website on Linux.
#
# The script uses docker and Samba.
#
# Consider adding IP security after completing this setup and verifying connectivity.

# Links:
# Docker - https://github.com/docker/docker-install
# Samba - https://github.com/dperson/samba

#Install Docker
sudo curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

#Create directories to store the website components.
#sudo rm -r ~/mywebsite		#Optionally delete the existing directory.

mkdir ~/smb
mkdir ~/smb/shares
mkdir ~/smb/shares/public
mkdir ~/smb/shares/departments
mkdir ~/smb/shares/departments/accounting
mkdir ~/smb/shares/users
mkdir ~/smb/shares/users/user1
mkdir ~/smb/shares/users/user1

#sudo docker stop smbserver				#Optionally stop any existing smbserver docker.
#sudo docker rm smbserver				#Optionally remove any existing smbserver docker.

#Setup Samba. Replace the variables in this line with appropriate values.
#The example setup below will create two users, each with their own share. It will also create a read-only public share as well as an accounting share that the two users can access.
sudo docker run -it --name smbserver \
			-v ~/smb/shares/public:/shares/public \
			-v ~/smb/shares/departments/accounting:/shares/departments/accounting \
			-v ~/smb/shares/users/user1:/shares/users/user1 \
			-v ~/smb/shares/users/user2:/shares/users/user2 \
			-p 139:139 -p 445:445 -e TZ=EST5EDT -d dperson/samba -p \
            -u "user1;supersecret" \
            -u "user2;extrasecret" \
            -s "public;/shares/public" \
            -s "accounting;/shares/departments/accounting;yes;no;no;user1,user2" \
            -s "user1;/shares/users/user1;yes;no;no;user1" \
            -s "user2;/shares/users/user2;yes;no;no;user2"

#List docker containers.
sudo docker ps

#View the web server docker container logs.
sudo docker logs mywebsite
