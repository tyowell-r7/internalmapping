#!/bin/bash

cd ..
mkdir mapping
cd mapping

#check for live hosts
nmap -iL ../ips -sn -PE -oG - | awk '/Up/{print $2}' > hosts

#scan for ftp
nmap -Pn -iL hosts -p 21 -oG - | awk '/open/{print $2}' > ftp-hosts.txt

#scan for ssh
nmap -Pn -iL hosts -p 22 -oG - | awk '/open/{print $2}' > ssh-hosts.txt

#scan for telnet
nmap -Pn -iL hosts -p 23 -oG - | awk '/open/{print $2}' > telnet-hosts.txt

#scan for databases
nmap -Pn -iL hosts -p 1433 -oG - | awk '/open/{print $2}' > mssql-hosts.txt
nmap -Pn -iL hosts -p 3306 -oG - | awk '/open/{print $2}' > mysql-hosts.txt
nmap -Pn -iL hosts -p 1521 -oG - | awk '/open/{print $2}' > oracle-hosts.txt
nmap -Pn -iL hosts -p 5432 -oG - | awk '/open/{print $2}' > postgres-hosts.txt

#scan for domain controllers
nmap -Pn -iL hosts -p 389 -oG - | awk '/open/{print $2}' > dc-hosts.txt

#scan for smb
nmap -Pn -iL hosts -p 445 -oG - | awk '/open/{print $2}' > smb-hosts.txt

#scan for web services
nmap -Pn -iL hosts -p 80,443,8080,8443 -oG - | grep open > http-hosts.txt
awk '/ 80\/open/{print "http://" $2 "/"}' < http-hosts.txt >> http-urls.txt
awk '/ 443\/open/{print "https://" $2 "/"}' < http-hosts.txt >> http-urls.txt
awk '/ 8080\/open/{print "http://" $2 ":8080/"}' < http-hosts.txt >> http-urls.txt
awk '/ 8443\/open/{print "https://" $2 ":8443/"}' < http-hosts.txt >> http-urls.txt
awk '/ 443\/open/{print $2}' < http-hosts.txt >> ssl-urls.txt


#scan for cisco smart install
nmap -Pn -iL hosts -p 4786 -oG - | awk '/open/{print $2}' > smi-hosts.txt

#scan for intel amt
nmap -Pn -iL hosts -p 16992 -oG - | awk '/open/{print $2}' > intelamt-hosts.txt

#scan for ipmi
nmap -sU -Pn -iL hosts -p 623 -oG - | awk '/open/{print $2}' > ipmi-hosts.txt

#scan for rdp
nmap -Pn -iL hosts -p 3389 -oG - | awk '/open/{print $2}' > rdp-hosts.txt

#delete empty files with no results
find /root/mapping -empty -type f -delete
