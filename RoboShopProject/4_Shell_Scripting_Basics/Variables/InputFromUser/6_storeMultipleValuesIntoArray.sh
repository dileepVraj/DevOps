#!/bin/bash

echo "Enter multiple values separated by spaces:"

read -a values

echo "you entered:"

# loop through the array and print each value.

for value in "${values[@]}"; do
echo "$value"
done
