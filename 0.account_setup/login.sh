#!/bin/bash

# Set current folder
DIR=$(pwd)

### Set color
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`


aws sts get-caller-identity  --no-cli-pager > /dev/null

if [ $? == 0 ]; 
then 
    echo ${green}"Please continue" ${reset}

else 
    echo ${red} """
        Please setup your account
        1. Create AWS IAM user with admin privileges
        2. Create access and secret key 
        3. run 
            
                aws configure    
                    Add Access key
                    Add Secret  Key
                    Add Region  (I really mean that, please add, otherwise you are going to cry)
                    Add Format
            
        
    """${reset}
fi 

if [ ! -f configurations.tfvars ];
then 
    echo """
        Please create 0.account_setup/configurations.tfvars
        And add the necessary values from README.md
    """
else 
    exit 1
fi
