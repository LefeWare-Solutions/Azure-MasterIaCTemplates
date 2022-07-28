  #Purge APIM
  $subscriptionId = ""
  $apimName = "lws-eastus-apim-d-app1"
  az rest --method delete --header "Accept=application/json" -u 'https://management.azure.com/subscriptions/2dc9c519-7c91-42b6-a530-8a7d765267f6/providers/Microsoft.ApiManagement/locations/eastus/deletedservices/lws-eastus-apim-d-app1?api-version=2020-06-01-preview'