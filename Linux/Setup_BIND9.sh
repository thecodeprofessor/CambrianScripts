#!/bin/bash
# The following script can be used to deploy a basic BIND9 installation on Linux.
#
# Consider adding IP security after completing this setup and verifying connectivity.

#Update and install the BIND9 components using apt-get.
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install bind9 bind9utils bind9-doc

#Create / Edit the BIND9 options file to enable forwarders.
sudo nano /etc/bind/named.conf.options

# Ensure that the following lines exist and are uncommented inside named.conf.options (omit the #s):
#
# forwarders {
#    8.8.8.8;
# };

#Create / Edit the BIND9 local file to include your new zone (domain name).
sudo nano /etc/bind/named.conf.local

# Ensure that the following lines exist and are uncommented inside named.conf.local (omit the #s):
#
# zone "yourname.local" {
#    type master;
#    file "/etc/bind/zones/db.yourname.local";
# };

#Create a new directory to hold your zone files.
sudo mkdir /etc/bind/zones/

#Create / Edit the BIND9 zone file to include basic settings nessisary to resolve your domain name records.
sudo nano /etc/bind/zones/db.yourname.local

# Ensure that the following lines exist and are uncommented inside db.yourname.local (omit the #s):
#
# $ttl 86400
# @                       IN      SOA     ns1.yourname.local. admin. (
#                         1348577024      ;serial number
#                         10800           ;refresh after 3 hours
#                         3600            ;retry after 1 hour
#                         604800          ;expire after 1 week
#                         38400 )         ;TTL of 10 hours
# 
#                         IN      NS              ns1.yourname.local.
# 
# ns1                     IN      A               10.0.0.21
# 
# client-srv-lin-1        IN      A               10.0.0.21
# client-srv-lin-2        IN      A               10.0.0.22

#Verify that the syntax of your configuration files is correct / valid.
sudo named-checkconf
sudo named-checkzone yourname.local /etc/bind/zones/db.yourname.local

#Restart the BIND9 service.
sudo systemctl restart bind9

#Allow the BIND9 service through the local firewall.
sudo ufw allow Bind9


