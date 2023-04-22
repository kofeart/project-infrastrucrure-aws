# aws-eks-cluster
## After cluster creation please run below:
```
aws eks update-kubeconfig --name YOURCLUSTERNAME --region CLUSTER-DEPLOYMENT-REGION
```
```
aws eks describe-cluster --name <cluster-name> --query cluster.status
```
### If you faced issue with deleting like this 
```
Security Group (sg-ID): DependencyViolation: resource sg-ID has a dependent object   status code: 400, request id: e208c396-e7e4-4497-8a05-11357abaaab4
```
### Run this command and Remove the dependencies
```
aws ec2 describe-instances --filters Name=subnet-id,Values=subnet-01d189462707a8da6
```