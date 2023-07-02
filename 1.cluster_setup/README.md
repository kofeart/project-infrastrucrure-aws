# Deploying EKS Cluster 
### Configure backend
```
source ../scripts/setenv.sh 
```
#### Apply
```
terraform apply -var-file ../0.account_setup/configurations.tfvars
```
