#!/bin/bash

source 0_utility_file.sh

TimeStamp=$(date +%F-%H-%M-%S)
LogFile="/tmp/"$0-$TimeStamp.log

validateToUser

# Installing maven & Java.
validate_and_install_packages maven -y >> $LogFile

# Creating user.
addUser roboshop

# creating application directory.
verifyAndCreateDirectory "/app"

# Downloading application code.
curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip >> $LogFile
validateAction $? "Downloading application code"

# Changing directory.
cd /app
validateAction $? "Changing to directory /app"

# unziping application code.
unzip -o /tmp/shipping.zip >> $LogFile
validateAction $? "Unziping application code"

# Installing dependencies.
mvn clean >> $LogFile
validateAction $? "Installing dependencies"

# Renaming shipping-1.0.jar to shipping.jar
mv target/shipping-1.0.jar shipping.jar
validateAction $? "Renaming Shipping-1.0.jar"

# setting up shipping.service file.
cp "/home/DevOps/RoboShopWithShellScript/ServiceFiles/shipping.service" "/etc/systemd/system/shipping.service"
validateAction $? "Setting shipping.service file"

# Reloading daemon.
systemctl daemon-reload
validateAction $? "Daemon-reload"

# Starting shipping service
systemctl start shipping
validateAction $? "Starting shipping service"

# Installing mysql client.
validate_and_install_packages mysql -y >> $LogFile

# Loading schema
mysql -h mysql.antman.fun -uroot -pRoboShop@1 < /app/schema/shipping.sql >> $LogFile
validateAction $? "Loading schema to mysql"

# Restarting shipping service.
systemctl restart shipping
validateAction $? "Restartings shiping service"



