# Instructions

----
### Step1
Please navigate to 
```
https://aws.amazon.com
```
----
### Step2
#### Login with your brand new account
#### Create new bucket call it 
```
terraform-project-WHATEVER_YOU_WANT      # It should start with terraform-project
Make sure it is in us-east-1 region
```

----
### Step3
#### Create a new file here called 
```
0.account_setup/configurations.tfvars
```
#### and add the following message there 
```
# Please get your AWS Domain
domain_name = "AWS_DOMAIN"

# Use AWS account email
email              = "EMAIL"

# Add bucketname you created above
bucket_name        = "terraform-project-WHATEVER_YOU_WANT"

# Add your AWS Account ID
aws_account = "YOUR_AWS_ACCOUNT_NUMBER"
```
----
### Step4

```
source login.sh 
```
----
