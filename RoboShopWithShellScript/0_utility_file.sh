#!/bin/bash





# colours
GreenColor="\e[5;42m"
RedColor="\e[5;41m"
YellowColor="\e[5;43m"
ResetColor="\e[0m"

# functions.

function validateAction(){
    if [ $1 -ne 0 ]; then
    echo -e "$RedColor $2 is failed $ResetColor"
    exit 1
    else 
        echo -e "$GreenColor $2 is success $ResetColor"
    fi
}

function validate_and_install_packages(){
    local status_1=$(dnf list installed $1)
    local statusCode=$?


    if [ "$statusCode" -eq 0 ];then
        echo -e "$YellowColor $1 is already installed $ResetColor"
    else
        echo -e "$YellowColor $1 isn't installed, installing....$ResetColor"
        dnf install $1 -y
        validateAction $? "Installing $1"
    fi
        
}

function addUser(){
    id $1
    local statusCode=$?
    if [ $statusCode -eq 0 ]; then
        echo -e "$YellowColor User $1 exists $ResetColor"
    else
        echo -e "$YellowColor User $1 doesn't exist, creating one $ResetColor"
        useradd $1
        validateAction $? "Adding user $1"
    fi
}

function validateToUser(){
    if [ $(id -u) -ne 0 ]; then
    echo -e "$RedColor This user didn't have root user privilages, please try with user with root privilages $ResetColor"
    else
        echo -e "$GreenColor This user is root user, good to go $ResetColor"
    fi
}

function verifyAndCreateDirectory(){
    test -d "$1"
    local statusCode=$?
    if [ $statusCode -eq 0 ]; then
    echo -e "$YellowColor directory $1 exists $ResetColor"
    else
    echo -e "$YellowColor directory $1 doesn't exists, creating one $ResetColor"
    mkdir $1
    fi
}


