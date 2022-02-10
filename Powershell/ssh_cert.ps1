az login
az account list

az account set --subscription 787db4c0-464e-4da2-99a2-399735598dcd

az provider register -n Microsoft.KeyVault

az group create -n rg-austeast-keystore1 -l australiaeast

az keyvault create -n keystore1Vault1 -g rg-austeast-keystore1 -l australiaeast --enabled-for-deployment

az keyvault certificate create --vault-name "keystore1Vault1" -n "cert1" -p @C:\Users\brian\Desktop\Classes\Azure\Policy\defult.json

az keyvault secret download --vault-name keystore1Vault1 -n cert1 -e base64 -f cert1.pfx
openssl pkcs12 -in cert1.pfx -out cert1.pem -nocerts -nodes
chmod 0400 cert1.pem
ssh-keygen -f cert1.pem -y > cert1.pub

az vm create -g rg-austeast-keystore1 -n vault-test1 --admin-username centos --image centos --ssh-key-value "$(cat cert1.pub)"

$POLICY=$(az keyvault certificate get-default-policy -o json)