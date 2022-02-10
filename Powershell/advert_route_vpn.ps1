Set-AzContext -SubscriptionId "233750e3-a3da-4a8b-bc2c-b1675731d161"

$gw = Get-AzVirtualNetworkGateway -Name vpn -ResourceGroupName project1 
Set-AzVirtualNetworkGateway -VirtualNetworkGateway $gw -CustomRoute 10.0.3.4/32

$gw = Get-AzVirtualNetworkGateway -Name $gw -ResourceGroupName project1 
$gw.CustomRoutes | Format-List