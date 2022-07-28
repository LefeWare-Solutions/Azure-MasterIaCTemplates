$rgName = "lws-rg-d-appgwhub"
$appgwName="lws-eastus-appgw-d-appgwhub"

# Get Azure Application Gateway
Connect-AzAccount
Set-AzContext -SubscriptionId 
$appgw=Get-AzApplicationGateway -Name $appgwName -ResourceGroupName $rgName
 
# Stop the Azure Application Gateway
Stop-AzApplicationGateway -ApplicationGateway $appgw
 
# Start the Azure Application Gateway
Start-AzApplicationGateway -ApplicationGateway $appgw