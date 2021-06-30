#!/bin/bash

# [vagrant@localhost vagrant]$ sudo yum search telnet
#
# YumRepo Error: All mirror URLs are not using ftp, http[s] or file.
#  Eg. Invalid release/repo/arch combination/
# removing mirrorlist with no valid mirrors: /var/cache/yum/x86_64/6/base/mirrorlist.txt
# Error: Cannot find a valid baseurl for repo: base

## Travas
if [ ! -f "/etc/yum.repos.d/CentOS-Base.repo" ];then
  printf "\n\t This script should only run in Centos 6\n\n"
  exit
fi

## Apontar o repositorio CentOS-Base para o vault.centos.org

[ ! -f "/etc/yum.repos.d/CentOS-Base.repo-bkp" ] && cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo-bkp

printf '\n\t CentOS-Base baseurl original\n'
grep baseurl /etc/yum.repos.d/CentOS-Base.repo
sed -i 's/^mirrorlist=/#mirrorlist=/g' /etc/yum.repos.d/CentOS-Base.repo
sed -i 's/^#baseurl=/baseurl=/g' /etc/yum.repos.d/CentOS-Base.repo
sed -i 's/mirror.centos.org/vault.centos.org/g' /etc/yum.repos.d/CentOS-Base.repo
printf '\n\t CentOS-Base baseurl updated\n'
grep baseurl /etc/yum.repos.d/CentOS-Base.repo

## site epel archive
## https://archives.fedoraproject.org/pub

### Instalar EPEL em linux 6
if [ ! -f "/etc/yum.repos.d/epel.repo" ]; then
  printf "\n\t repository epel not installed, installing from archives.fedoraproject.org \n\n"
  yum localinstall https://archives.fedoraproject.org/pub/archive/epel/6/x86_64/epel-release-6-8.noarch.rpm -y
fi

[ ! -f "/etc/yum.repos.d/epel.repo-bkp" ] && cp /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel.repo-bkp

printf '\n\t epel baseurl original\n'
grep baseurl /etc/yum.repos.d/epel.repo
cp /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel.repo-bkp
sed -i 's/^mirrorlist=/#mirrorlist=/g' /etc/yum.repos.d/epel.repo
sed -i 's/^#baseurl=/baseurl=/g' /etc/yum.repos.d/epel.repo
sed -i 's/download.fedoraproject.org/archives.fedoraproject.org/g' /etc/yum.repos.d/epel.repo
sed -i 's/pub\/epel/pub\/archive\/epel/g' /etc/yum.repos.d/epel.repo

printf '\n\t epel baseurl updated\n'
grep baseurl /etc/yum.repos.d/epel.repo

yum clean all
printf '\n\t Testing\n\n'
yum search telnet 
yum search htop
