#!/bin/bash

#The -e option in the echo command enables the interpretation of escape sequences, allowing you to include special characters such as newlines 
# (\n), tabs (\t), etc., in the output.

read -s -p "Enter your password:" password
echo -e "\nPassword received."