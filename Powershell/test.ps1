New-AzResourceGroup -Name myResourceGroup -Location eastus

New-AzVm -ResourceGroupName "myResourceGroup" -Name "myVM" -Location eastus -VirtualNetworkName "myVnet" -SubnetName "mySubnet" -SecurityGroupName   "myNetworkSecurityGroup"