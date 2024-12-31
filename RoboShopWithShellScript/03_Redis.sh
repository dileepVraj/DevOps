#!/bin/bash

source 0_utility_file.sh

TimeStamp=$(date +%F-%H-%M-%S)
LogFile="/tmp/"$0-$TimeStamp.log

# validating user.
validateToUser

# Installing Redis repo file as rpm.
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
validateAction $? "Installing Redis repo"

# Enable Redis 6.2 from package streams.
dnf module enable redis:remi-6.2 -y
validateAction $? "Enabling redis 6.2"

# Installing redis.
validate_and_install_packages redis

# Usually Redis opens the port only to localhost(127.0.0.1), meaning this service can be accessed by 
# the application that is hosted on this server only. However, we need to access this service to be 
# accessed by another server, So we need to change the config accordingly.


# Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/redis.conf & /etc/redis/redis.conf
sed -i 's/127.0.0.0/0.0.0.0/' /etc/redis.conf
validateAction $? "Updating listen address from 127.0.0.1 to 0.0.0.0"

# Enabling redis
systemctl enale redis 
validateAction "Enabing redis"

# Starting redis
systemctl start redis
validateAction "Starting redis"



