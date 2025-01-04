#!/bin/bash

source 0_utility_file.sh

TimeStamp=$(date +%F-%H-%M-%M)
LogFile="/tmp/"$0-$TimeStamp.sh

# validate user
validateToUser

# Installing go language.
dnf install golang -y >> $LogFile
validateAction $? "Installing go-lang"

# Creatig user.
add_user "roboshop"

# creating application directory.
verifyAndCreateDirectory "/app"

# Downloading appliaction code.
curl -L -o /tmp/dispatch.zip https://roboshop-builds.s3.amazonaws.com/dispatch.zip >> $LogFile
validateAction $? "Downloading application code"

# changing to application directory.
cd /app
validateAction $? "Change directory to /app"

# Unziping application code.
unzip -o /tmp/dispatch.zip
validateAction $? "Unziping application code"

# Downloading dependencies and building code.
cd /app 
go mod init dispatch
go get 
go build
validateAction $? "Downloading dependencies and code build"

# creating service for dispatch.
cp /home/DevOps/RoboShopWithShellScript/ServiceFiles/dispatch.service /etc/systemd/system/dispatch.service
validateAction $? "creating service for dispatch"

# Reloading daemon.
systemctl daemon-reload
validateAction $? "Reloading daemon"

# Enabling dispatch service.
systemctl enable dispatch
validateAction $? "Enabling dispatch service"

# Starting dispatch service.
systemctl start dispatch
validateAction $? "Starting dispatch"
