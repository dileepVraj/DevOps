#!/bin/bash

source 0_utility_file.sh

TimeStamp=$(date +%F-%H-%M-%S)
LogFile="/tmp/"$0-$TimeStamp.sh

# validating user.
validateToUser

# Disabling default mysql module.
dnf module disable mysql -y >> $LogFile
validateAction $? "Disabling default mysql module"

# setting up mysql-5.7 repo file.
cp '/home/DevOps/RoboShopWithShellScript/RepoFiles/mysql.repo' '/etc/yum.repos.d/mysql.repo'
validateAction $? "Setting up mysql-5.7 repo"

# Installing mysql server.
validate_and_install_packages mysql-community-server -y

# Enabling mysql server.
systemctl enable mysqld
validateAction $? "Enabling mysql server"

# Starting mysql server.
systemctl start mysqld
validateAction $? "Starting mysqld server"

# Changing mysql default password.
mysql_secure_installation --set-root-pass RoboShop@1
validateAction $? "Changing default password"
 