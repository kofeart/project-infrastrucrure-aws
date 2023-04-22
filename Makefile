cluster_setup:
	cd 1.cluster_setup && bash ../scripts/setenv.sh && terraform apply -var-file ../0.account_setup/configurations.tfvars --auto-approve

tools_setup:
	cd 2.tools_setup &&  bash ../scripts/setenv.sh && terraform apply -var-file ../0.account_setup/configurations.tfvars --auto-approve



destroy-cluster_setup:
	cd 1.cluster_setup && bash ../scripts/setenv.sh && terraform destroy -var-file ../0.account_setup/configurations.tfvars --auto-approve

destroy-tools_setup:
	cd 2.tools_setup &&  bash ../scripts/setenv.sh && terraform destroy -var-file ../0.account_setup/configurations.tfvars --auto-approve
