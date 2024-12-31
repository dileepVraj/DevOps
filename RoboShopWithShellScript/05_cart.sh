#!/bin/bash

source 0_utility_file.sh

TimeStamp=$(date +%F-%H-%M-%S)
LogFile="/tmp/"$0-$TimeStamp.log

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
curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip >> $LogFile
validateAction $? "Downloading application code"

# changing directory.
cd "/app"
validateAction $? "Changing directory to /app" 

# Unziping application code from user.zip
unzip -o /tmp/cart.zip >> $LogFile
validateAction $? "Unziped application code."

# changing directory.
cd "/app"
validateAction $? "Changing directory to /app" 

# Installing npm.
npm install >> $LogFile
validateAction $? "Installing npm"

# We need to setup a new service in systemd so systemctl can manage this service
cp '/root/DevOps/RoboShopWithShellScript/ServiceFiles/cart.service' '/etc/systemd/system/cart.service'
validateAction $? "Copying cart.service file to /etc/systemd/system directory."

# Reloading daemon to load user.service
systemctl daemon-reload 
validateAction $? "Daemon reloading"

# Enabing user.service
systemctl enable cart >> $LogFile
validateAction $? "Enabling cart.service"

# Starting user.service
systemctl start cart
validateAction $? "Starting cart.service"

