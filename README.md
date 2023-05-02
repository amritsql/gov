# for aws resources #
Terraform v1.4.6 is used for all terraform operations and python 3.8 for python script
## private subnet az1 and az2 created
## public subnet az1 and az2 created
## create gateway endpoint to connect private subnet to s3
## edit route table to get s3 connected via vpce endpoint 


#### NOTE ####
Have removed aws keys, also did not create another s3 post build step as its dependent on terraform apply. Plan can be viewed for infra verification

### ASSUMPTIONS ###
1) have not used varilabes if required can be variables can be placed at a common place so resources can be updates easily
2) terraform state could be stored as backend in s3 and dynamodb. This is demo hence not required
3) have run only terraform plan to show the pipeline results
4) post deployment steps are based on deployment hence havent create a pipeline which could be created as a dependent pipeline to check for autoscaling refresh
5) simple grafana and prometheous is used both havent done it via yaml files inbetween have download and used online resources to setuo directly though have mentioned the steps
