#!/bin/bash

# Set current folder
DIR=$(pwd)

### Set color
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`


aws sts get-caller-identity   > /dev/null

if [ $? == 0 ]; 
then 
    # Setup python 
    echo "${green}Setting up Python ${reset}"
    python3  -m venv workspace 
    source workspace/bin/activate
    echo "${green}Setting up AWS CLI ${reset}"
    pip install awscli -q
    # Setup Kubectl get ns 
    curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.23.15/2023-01-11/bin/linux/amd64/kubectl --silent
    chmod +x kubectl
    mv kubectl ~/.local/bin
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
    exit 1
else 
    echo ${green}"configurations.tfvars file is created" ${reset}
fi

# Setup python aws cli
