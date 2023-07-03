#!/bin/bash
set -xe
# Set current folder
DIR=$(pwd)
echo $DIR
### Set color
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`


#########################################################################################################
# Check if the configurations.tfvars file is created
if [ -f ../0.account_setup/configurations.tfvars ]
then 
  echo ${green} "Please continue" ${reset}
else 
  echo """
  
          ${red}Please create this file first ../0.account_setup/configurations.tfvars ${reset}
          
  """
  return
fi



#########################################################################################################
BUCKET_NAME=`cat ../0.account_setup/configurations.tfvars | grep bucket_name | awk '{print $3}' | tr -d '"'`
if  [ -z  $BUCKET_NAME ];
then 
  echo """
      ${red}Did you add bucket_name  in ../0.account_setup/configurations.tfvars  ${reset}
      
      bucket_name=YOUR_bucket_name
      """
  return
else
  echo ${green} "Bucket name is given" ${reset}
fi


#########################################################################################################
REGION=`cat ../0.account_setup/configurations.tfvars | grep -i REGION | awk '{print $3}' | tr -d '"'`

if  [ -z  $REGION ];
then 
  echo """
      ${red}Did you add REGION  in ../0.account_setup/configurations.tfvars  ${reset}
      
      region=your_region
      """
  return
else
  echo ${green} "Bucket name is given" ${reset}
fi


#########################################################################################################
PACKAGE_NAME="tfenv"
if ! which $PACKAGE_NAME &> /dev/null;
then 
  echo """
      ${red}
      Please install tfenv before moving forward
        Instructions are here:
          git clone --depth=1 https://github.com/tfutils/tfenv.git ~/.tfenv
          echo 'export PATH="\$HOME/.tfenv/bin:\$PATH"' >> ~/.bash_profile
          source ~/.bash_profile 
          tfenv install TERRAFORM_VERSION  
          tfenv use TERRAFORM_VERSION
        ${reset}
  """
  return
else 
  echo ${green} "tfenv is installed please continue" ${reset}
fi

#########################################################################################################



cat << EOF > "$DIR/backend.tf"
terraform {
  backend "s3" {
    bucket = "${BUCKET_NAME}"
    key = "dev`pwd`"
    region = "${REGION}"
  }
}
EOF
cat "$DIR/backend.tf"


terraform init -reconfigure
if [ $? -eq 0 ];
then 
  tfenv install 1.1.1
  tfenv use 1.1.1
  terraform init -reconfigure
fi



# Setup python 
echo "${green}Setting up Python ${reset}"
python3  -m venv workspace 
source workspace/bin/activate
echo "${green}Setting up AWS CLI ${reset}"
pip install awscli -q


echo """
     ${green}"You are good to go"${reset}
"""
