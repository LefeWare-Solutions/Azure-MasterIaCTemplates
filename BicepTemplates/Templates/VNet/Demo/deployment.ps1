az group create --name lws-rg-dev-common --location eastus

az deployment group create  `
--template-file ../vnet.bicep `
--parameters ./main.parameters.dev.json `
--resource-group lws-rg-dev-common 