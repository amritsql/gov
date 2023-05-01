#!/bin/bash

aws s3 cp s3://bucketname/index.html ./index.html.sh

# Get cksum of first file
file1_cksum=$(cksum index.html | awk '{ print $1 }')

# Get cksum of second file
file2_cksum=$(cksum index.html.sh | awk '{ print $1 }')

# Compare cksums
if [ "$file1_cksum" == "$file2_cksum" ]
then
    echo "Checksums match"
else
    echo "Checksums do not match"
    ./sync.sh
    aws autoscaling start-instance-refresh --auto-scaling-group-name replace-autoscaling-group-name --region ap-southeast-1
fi

