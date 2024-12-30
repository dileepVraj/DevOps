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

function validateInstallation(){
    local status=$(dnf list installed $1)

    if [ $status -eq 0 ];then
        echo -e "$YellowColor $1 is already installed $ResetColor"
    else
        echo -e "$YellowColor $1 isn't installed.$ResetColor"
    fi
        
}

function validateToUser(){
    if [ $(id -u) -ne 0 ]; then
    echo -e "$RedColor This user didn't have root user privilages, please try with user with root privilages $ResetColor"
    else
        echo -e "$GreenColor This user is root user, good to go $ResetColor"
    fi
}


