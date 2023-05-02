## copy  source code files here from src directory i.e index.html, counter.js, counter.css


## execution sequence ##
0) python s3.py # this will make all index.html files to uppercase, create a bucket if dosent exists
1) ./sync.sh # sync files from local directory i.e index.html, counter.css and counter.js to s3 bucket
2) ./test.sh # check files if cksum changes it will refresh autoscaling group and execute a new template

# edit test.sh ## 
## replace bucketname with your actual bucket ##
## this will refresh autoscaling group if there is change in index.html

# edit s3.py
## replace bucket_name with your actual bucket ##
## this will change the index.html to uppercase ##

# edit sync.sh
## replace bucket name here ##
## this will sync files from local to s3 ##
