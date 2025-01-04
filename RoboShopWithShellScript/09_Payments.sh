#!/bin/bash

source 0_utility_file.sh

TimeStamp=$(date +%F-%H-%M-%S)
LogFile="/tmp/"$0-$TimeStamp.sh

# Validating usre.
validateToUser

# Installing python 3.6.
dnf install python36 gcc python3-devel -y >> $LogFile
validateAction $? "Installing Python 3.6"

# Creating user.
add_user "roboshop"

# Crating application directory.
verifyAndCreateDirectory "/app"

# changing to application directory.
cd /app
validateAction $? "change directory to /app"

# Downloading application code.
curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip >> $LogFile
validateAction $? "Downloading application code"

# Unzipping application code.
unzip -o /tmp/payment.zip >> $LogFile
validateAction $? "unzipping application code"

# Installing dependencies from requirements.txt file.
pip3.6 install -r requirements.txt >> $LogFile
validateAction $? "Installing dependencies"

# Creating service for payment.
cp /home/DevOps/RoboShopWithShell/ServiceFiles/payments.service /etc/systemd/system/payments.service
validateAction $? "Copying payment.service file and creating service"

# Re-loading daemon.
systemctl daemon-reload
validateAction $? "Daemon reload"

# Enabling payments service.
systemctl enable payments
validateAction $? "Enabling payments"

# Starting payments service.
systemctl start payments
validateAction $? "Starting payments"

