#!/bin/bash

source 0_utility_file.sh

TimeStamp=$(date +%F-%H-%M-%S)
LogFile="/tmp/"$0-$TimeStamp.log


validateToUser

# Disabling default node-js version.
dnf module disable nodejs -y
validateAction $? "Disabling default nodejs version"

# Enabling nodejs:18
dnf module enable nodejs:18 -y
validateAction $? "Enabling nodejs:18"

# Install nodejs.
validateInstallation nodejs
dnf install nodejs -y
validateAction $? "Installing nodejs"

# Verifying and adding user.
addUser roboshop
validateAction $? "Adding user roboshop"

# creating /app directory.
verifyAndCreateDirectory "/app"
validateAction $? "Creating /app directory"

# Downloading appliaction code.
curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip
validateAction $? "Downloading application code"

# Change to /app directory.
cd /app
validateAction $? "Changing to /app directory"

# unziping appliactio code in /app directory.
unzip /tmp/catalogue.zip
validateAction $? " unzipping application code in /app directory "

# installing node package manager.
npm install
validateAction $? "installing node package manager"

# copying catalogue.service to /etc/systemd/system/ directory.
cp "/home/DevOps/