ENVFILE := ./.env
EXEC := op run --env-file=$(ENVFILE) --

default:
	@echo "Please specify a target to build"
	@exit 1

init:
	$(EXEC) terraform init $(ARGS)

apply:
	$(EXEC) terraform apply $(ARGS)

destroy:
	$(EXEC) terraform destroy $(ARGS)

fmt:
	terraform fmt -recursive

inject:
	op inject -f -i terraform.tfvars.tpl -o terraform.tfvars

lint:
	tflint --recursive

dashboard:
	@echo "BEARER TOKEN\n"
	@kubectl get secret kubernetes-dashboard-token -n homelab -o jsonpath={".data.token"} | base64 -d
	@echo "\n\n"
	kubectl port-forward svc/kubernetes-dashboard-kong-proxy 8443:443 -n homelab