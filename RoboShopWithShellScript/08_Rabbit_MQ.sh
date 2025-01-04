#!/bin/bash

source 0_utility_file.sh

TimeStamp=$(date +%F-%H-%M-%S)
LogFile="/tmp/"$0-$TimeStamp.log

# validating user
validateToUser

# RabbitMQ is a messaging Queue which is used by some components of the applications.
# Configure YUM Repos from the script provided by vendor.

# Installing errlang repo.
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash 
validateAction $? "Downloading errlang repo"

# Setupping Rabbit_mq server repository.
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash 
validateAction $? "Settingup Rabbit my server repository"

# Installing rabbit_mq
dnf install rabbitmq-server -y >> $LogFile
validateAction $? "Installation of rabbit_mq"

# Enable rabbit_mq server.
systemctl enable rabbitmq-server
validateAction $? "Enabling rabbit_mq server"

# Starting rabbit_mq server.
systemctl start rabbitmq-server
validateAction $? "Starting rabbit_mq server"

# RabbitMQ comes with a default username / password as guest/guest. But this user cannot be used to 
# connect. Hence, we need to create one user for the application.

# Creating user in rabbit_mq.
add_user_if_not_exists() {
    local username=$1
    local password=$2

    # Check if the user already exists
    if rabbitmqctl list_users | grep -q "^$username[[:space:]]"; then
        echo "User '$username' already exists. Skipping user creation."
    else
        echo "User '$username' does not exist. Creating user..."
        rabbitmqctl add_user $username $password
        if [ $? -eq 0 ]; then
            echo "User '$username' successfully created."
        else
            echo "Failed to create user '$username'."
            exit 1
        fi
    fi
}
add_user_if_not_exists "roboshop" "roboshop123"

# Setting up permissions.
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
validateAction $? "Setting up permissions"
