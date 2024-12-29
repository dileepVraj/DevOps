#!/bin/bash

# The -t option specifies a timeout for input, meaning the command will wait for 
# user input only for the specified number of seconds.

read -t 10 -p "Enter your name(you have 5 seconds): " name
echo "Name entered: $name"