az vm create --name hubvm `
--resource-group vm-rg `
--location eastus `
--image ubuntults `
--subnet $(az network vnet subnet show -g network-rg --vnet-name Hub -n default -o tsv --query id) `
--ssh-dest-key-path  "C:\Users\brian\Desktop\SSH_Keys\bastion.pub"`
--admin-username "azureuser" `
--no-wait `
--public-ip-address """"

az vm create --name spoke1 `
--resource-group vm-rg `
--location westus `
--image ubuntults `
--subnet $(az network vnet subnet show -g network-rg --vnet-name spoke1 -n default -o tsv --query id) `
--admin-password "0987^%$#poiuYTRE" `
--admin-username "azureuser" `
--no-wait `
--public-ip-address """"

az vm create --name spoke2 `
--resource-group vm-rg `
--location eastus2 `
--image ubuntults `
--subnet $(az network vnet subnet show -g network-rg --vnet-name spoke2 -n default -o tsv --query id) `
--admin-password "0987^%$#poiuYTRE" `
--admin-username "azureuser" `
--no-wait `
--public-ip-address """"