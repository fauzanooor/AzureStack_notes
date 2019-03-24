###### add gateway subnet, saran harus dari portal, karena dari powershell ngga tau kenapa, error terus karena resourceID nya ngga ke generate
## add gateway subnet
#$vnet = Get-AzureRmVirtualNetwork -Name <vnet-name> -ResourceGroupName <resource-group-name>
#$vnetgwsubnet = Add-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name 'GatewaySubnet' -AddressPrefix "10.0.0.0/27"
#$vnetgwsubnetget =  Get-AzureRmVirtualNetworkSubnetConfig -Name "GatewaySubnet" -VirtualNetwork $vnet
#$vnetgwpip = New-AzureRmPublicIpAddress -Name <pip-for-gatewaysubnet> -ResourceGroupName <resource-group-name> -Location <location-name> -AllocationMethod Dynamic
#$ngwipconfig = New-AzureRmVirtualNetworkGatewayIpConfig -Name ipconfig-subnetgw -SubnetId $vnetgwsubnetget.Id -PublicIpAddressId $vnetgwpip.Id


## create local network gateway (lng)
New-AzureRmLocalNetworkGateway -Name <lng-name> `
    -ResourceGroupName <resource-group-name> -Location <location-name> `
    -GatewayIpAddress '<target-public-ip-address>' -AddressPrefix '20.0.0.0/24'
$lng = Get-AzureRmLocalNetworkGateway -ResourceGroupName <resource-group-name> -Name <lng-name>


## create virtual network gateway (vng)
New-AzureRmVirtualNetworkGateway -Name <vng-name> `
    -ResourceGroupName <resource-group-name> -Location <location-name> `
    -GatewaySku HighPerformance  -IpConfigurations $ngwipconfig `
    -GatewayType Vpn -VpnType RouteBased
$vng = Get-AzureRmVirtualNetworkGateway -ResourceGroupName <resource-group-name> -Name <vng-name>


## create connection
New-AzureRmVirtualNetworkGatewayConnection -Name <connection-name 
    -ResourceGroupName <resource-group-name> -Location <location-name> `
    -VirtualNetworkGateway1 $vng -LocalNetworkGateway2 $lng `
    -ConnectionType IPsec -SharedKey '<pre-shared-key'