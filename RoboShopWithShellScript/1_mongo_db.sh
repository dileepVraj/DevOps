#!/bin/bash

source 0_utility_file.sh

TimeStamp="$(date +%F-%H-%M-%S)"
LogFile="/tmp/"$0-$TimeStamp.log

validateToUser


# Copying mongo.repo confi to '/etc/yum.repos.d' directory.
cp /home/DevOps/RoboShopWithShellScript/RepoFiles/mongo.repo /etc/yum.repos.d/mongo.repo
validateAction $? "Copying mongo.repo file "

# Installing mongodb
validateInstallation "mongodb-org"
dnf install mongodb-org -y >> $LogFile
validateAction $? "Installing mongodb-org"

# Enable mongodb
systemctl enable mongod >> $LogFile
validateAction $? "Enabling mongodb"

# Starting mongodb
systemctl start mongod >> $LogFile
validateAction $? "Starting mongodb"

# Modifying localhost IP addess 127.0.0.1 to 0.0.0.0.
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
validateAction $? "Modifying local host IP to 0.0.0.0"

# Restarting mongodb.
systemctl restart mongod
validateAction $? "Restarting mongod"






