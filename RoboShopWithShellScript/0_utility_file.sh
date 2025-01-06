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

function validate_and_install_packages() {
    dnf list installed $1 >> /dev/null
    local statusCode=$?

    if [ "$statusCode" -eq 0 ]; then
        echo -e "$YellowColor $1 is already installed $ResetColor"
    else
        echo -e "$YellowColor $1 isn't installed, installing....$ResetColor"
        
        # Background task to show progress message
        while true; do
            echo -ne "$YellowColor $1 is installing... $ResetColor\r"
            sleep 2
        done &
        local spinner_pid=$!

        # Install the package
        dnf install $1 -y >> /dev/null
        local installStatus=$?

        # Kill the background progress message
        kill $spinner_pid
        wait $spinner_pid 2>/dev/null

        # Validate installation
        if [ $installStatus -eq 0 ]; then
            echo -e "$GreenColor $1 installation completed successfully. $ResetColor"
        else
            echo -e "$RedColor $1 installation failed. $ResetColor"
        fi
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
    mkdir -p $1
    fi
}


