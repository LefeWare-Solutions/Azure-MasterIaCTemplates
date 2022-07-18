# Introduction 
The following project contains Infrasructure as Code (IaC) Templates in the following 3 languages:
1. Azure Resource Manager (ARM)
2. BICEP
3. Terraform

We at LefeWare Solutions leverage these templates on multiple projects

# Why you should always use Infrastructure as Code for deploying
We at LefeWare Solutions believe strongly that IaC should ALWAYS be used for deploying infrastructure resources for the following reasons:
1. Avoid human error and redundancy
2. Automate infrastructure deployments
3. Easily reproduce deployments in multiple environments
4. IaC code is checked into source control and therefore you can easily 


# Which IAC language should I leverage?

##ARM

##BICEP

##Terraform

---
# Publishing Pipelines


terraform init -backend-config=backend.conf
terraform plan -var-file="dev-variables.tfvars"
terraform apply -var-file="dev-variables.tfvars"

---
# Leveraging these tempaltes from your project

