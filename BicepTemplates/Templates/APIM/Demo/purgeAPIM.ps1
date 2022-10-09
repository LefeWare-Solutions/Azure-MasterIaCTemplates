  #Purge APIM
  $subscriptionId = ""
  $apimName = "lws-eastus-apim-d-app1"

  
  az login
  az rest --method delete --header "Accept=application/json" -u 'https://management.azure.com/subscriptions/27ba7e14-cda9-4165-8ff9-bb4d7fcecea2/providers/Microsoft.ApiManagement/locations/centralus/deletedservices/sf-marc3-cus-apim-p-common?api-version=2020-06-01-preview'