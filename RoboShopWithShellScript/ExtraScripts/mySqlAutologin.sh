#!/usr/bin/expect

# Spwan the MySQL command.
spawn mysql -u root -p

# wait for the password prompt.
expect "Enter password:"

# Send password followed by a new line.
send "$defaultPassword\r"

# Hand control over to the user.
interact
