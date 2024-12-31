#!/bin/bash

source 0_utility_file.sh

TimeStamp=$(date +%F-%H-%M-%S)
LogFile="/tmp/"$0-$TimeStamp.log


# Validating user.
validateToUser

# Disabling default node-js version.
dnf module disable nodejs -y >> $LogFile
validateAction $? "Disabling default nodejs version"

# Enabling nodejs:18
dnf module enable nodejs:18 -y >> $LogFile
validateAction $? "Enabling nodejs:18"

# Install nodejs.
validate_and_install_packages nodejs >> $LogFile


# Verifying and adding user.
addUser roboshop >> $LogFile
# validateAction $? "Adding user roboshop"

# creating /app directory.
verifyAndCreateDirectory "/app" >> $LogFile
# validateAction $? "Creating /app directory"

# Downloading appliaction code.
curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip >> $LogFile
validateAction $? "Downloading application code"

# Change to /app directory.
cd /app
validateAction $? "Changing to /app directory"

# unziping appliactio code in /app directory.
unzip /tmp/catalogue.zip >> $LogFile
validateAction $? " unzipping application code in /app directory "

# installing node package manager.
npm install >> $LogFile
validateAction $? "installing node package manager"

# copying catalogue.service to /etc/systemd/system/ directory.
cp /home/DevOps/RoboShopWithShellScript/ServiceFiles/catalogue.service /etc/systemd/system/catalogue.service
validateAction $? "Copying catalogue.service"

# Reloading deamon.
systemctl daemon-reload >> $LogFile
validateAction $? "Reloading daemon"

# Enabling catalogue"
systemctl enable catalogue >> $LogFile
validateAction $? "Enabling catalogue"

# Starting catalogue service
systemctl start catalogue >> $LogFile
validateAction $? "Starting catalogue"

# Copying repo configuration of mongodb shell to '/etc/yum.repos.d/' directory.
cp "/home/DevOps/RoboShopWithShellScript/RepoFiles/mongoClient.repo" "/etc/yum.repos.d/mongo.repo"
validateAction $? "Mongo database client installation"

# validating and istalling mongodb shell.
validate_and_install_packages mongodb-org-shell >> $LogFile

# Loading schema to mongodb.
mongo --host mongodb.antman.fun </app/schema/catalogue.js
validateAction $? "Loading schema to mongodb"



