az group create --name lws-rg-dev-common --location eastus

az deployment group create  `
--template-file ../appgateway.bicep `
--parameters ./appgateway.parameters.dev.json `
--resource-group lws-rg-dev-common 