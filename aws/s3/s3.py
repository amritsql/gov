import os
import boto3
import requests


# Replace with the S3 bucket name you want to create
bucket_name = 'mys3bucksg'


# Check if the S3 bucket exists, and create it if it doesn't
s3 = boto3.client('s3', region_name='ap-southeast-1')
if bucket_name not in [bucket['Name'] for bucket in s3.list_buckets()['Buckets']]:
   s3.create_bucket(Bucket=bucket_name,CreateBucketConfiguration={'LocationConstraint': 'ap-southeast-1'})



# Open the file for reading
with open('index.html', 'r') as input_file:
    # Read the content of the file and convert it to uppercase
    content = input_file.read().upper()

# Open the file for writing
with open('output.txt', 'w') as output_file:
    # Write the uppercase content to the output file
    output_file.write(content)

# Remove the input file
os.remove('index.html')

# Rename the output file to input file
os.rename('output.txt', 'index.html')
