#!/bin/bash



# Time stamp
TimeStamp=$(date +%F-%H-%M-%S)

# colours
GreenColor="\e[5;42m"
RedColor="\e[5;41m"
YellowColor="\e[5;43m"
ResetColor="\e[0m"

# functions.

function validateAction(){
    if [ $1 -ne 0 ]; then
    echo -e "$RedColor $2 installation is failed $ResetColor"
    else 
        echo -e "$GreenColor $2 installation is success $ResetColor"
    fi
}

function validateToUser(){
    if [ $(id -u) -ne 0 ]; then
    echo "$RedColor This user didn't have root user privilages, please try with user with root privilages $ResetColor"
    else
        echo "$GreenColor This user is root user, good to go $ResetColor"
    fi
}


