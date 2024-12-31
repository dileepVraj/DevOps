#!/bin/bash

source 0_utility_file.sh

TimeStamp=$(date +%F-%H-%M-%S)
LogFile="/tmp/"$0-$TimeStamp.sh

# Validating user.
validateToUser

# Disabling default nodejs version.
dnf module disable nodejs -y >> $LogFile
validateAction $? "Disabling nodejs"

# Enabling default nodejs version.
dnf module enable nodejs:18 -y >> $LogFile
validateAction $? "Enabling nodejs:18"

# Installing nodejs.
dnf install nodejs -y >> $LogFile
validateAction $? "Installing nodejs"

# Adding user.
addUser "roboshop" >> $LogFile

# Creating application directory.
verifyAndCreateDirectory "/app"

# Downloading application code.
curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip >> $LogFile
validateAction $? "Downloading application code"

# changing directory.
cd "/app"
validateAction $? "Changing directory to /app" 

# Unziping application code from user.zip
unzip -o /tmp/user.zip >> $LogFile
validateAction $? "Unziped application code."

# Installing npm.
npm install >> $LogFile
validateAction $? "Installing npm"

# We need to setup a new service in systemd so systemctl can manage this service
cp '/home/DevOps/RoboShopWithShellScript/ServiceFiles/user.service' '/etc/systemd/system/user.service'
validateAction $? "Copying user.service file to /etc/systemd/system directory."

# Reloading daemon to load user.service
systemctl daemon-reload 
validateAction $? "Daemon reloading"

# Enabing user.service
systemctl enable user >> $LogFile
validateAction $? "Enabling user.service"

# Starting user.service
systemctl start user
validateAction $? "Starting user.service"

# For the application to work fully functional we need to load schema to the Database.

# NOTE: Schemas are usually part of application code and developer will provide them as part of development.

# We need to load the schema. To load schema we need to install mongodb client.

# To have it installed we can setup MongoDB repo and install mongodb-client

cp /home/DevOps/RoboShopWithShellScript/RepoFiles/mongoClient.repo /etc/yum.repos.d/mongo.repo
validateAction $? "creating mongodb-client repo"

# Installing mongodb-client.
dnf install mongodb-org-shell -y >> $LogFile

# Loading schema to mongodb.
mongo --host mongodb.antman.fun </app/schema/user.js >> $LogFile
validateAction $? "Loading schema to mongodb"

