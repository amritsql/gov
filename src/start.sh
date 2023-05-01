#!/bin/sh

# Start Nginx in the background
service nginx start

# Check if Nginx is up and running
while ! curl -s http://localhost:80 > /dev/null
do
    echo "Waiting for Nginx to start..."
    sleep 1
done

# If Nginx is up and running, print a message and exit
echo "Nginx is up and running."
