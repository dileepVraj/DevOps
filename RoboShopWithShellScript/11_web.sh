#!/bin/bash

source 0_utility_file.sh

TimeStamp=$(date +%F-%H-%M-%S)
LogFile="/tmp/"$0-$TimeStamp.sh

# validating user.
validateToUser

# Installing nginx web-server.
dnf install nginx -y >> $LogFile
validateAction $? "Installing nginx"

# Enabling nginx.
systemctl enable nginx
validateAction $? "Enabling nginx"

# Starting nginx.
systemctl start nginx
validateAction $? "Starting nginx"

# Removing the default content the web server nginx is serving.
rm -rf /usr/share/nginx/html/*
validateAction $? "Removing default content"

# Downloading front-end code.
curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip >> $LogFile
validateAction $? "Downloading front-end code"

# changing to html directory 
cd /usr/share/nginx/html
validateAction $? "Change directory to html"

# Extracting front-end code.
unzip -o /tmp/web.zip >> $LogFile
validateAction $? "Unziping front-end code."

# creating reverse proxy config file.
cp /home/DevOps/RoboShopWithShell/ServiceFiles/roboshop.conf /etc/nginx/default.d/roboshop.conf
validateAction $? " creating reverse proxy "

# restarting nginx.
systemctl restart nginx
validateAction $? "Restarting nginx"
