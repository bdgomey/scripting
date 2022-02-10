#run the following commands
az login
az account set --subscription "233750e3-a3da-4a8b-bc2c-b1675731d161"
Set-AzContext -SubscriptionId "233750e3-a3da-4a8b-bc2c-b1675731d161"
#f68ac74a-bcca-4d13-88c3-67f9605565c7 students
#233750e3-a3da-4a8b-bc2c-b1675731d161 training_sandbox

$data = Import-Csv "C:\Users\brian\Downloads\Azureresourcegroups (1).csv"


ForEach($user in $data) {
    
    az group create -n $($user.Name) -l "eastus" --tags Name=$($user.Name) Email=$($user.User_Principal_Name) Department=$($user.department)

}


ForEach($user in $data) {
    
    az role assignment create --assignee $($user.User_Principal_Name) --role "Owner" --resource-group $($user.Name)

}

ForEach($user in $data) {
    
    az role assignment create --assignee $($user.User_Principal_Name) --role "Reader" --subscription "f68ac74a-bcca-4d13-88c3-67f9605565c7"

}

ForEach($user in $data) {
    
    Remove-AzResourceGroup -Name $($user.Name) -force

}

Remove-AzResourceGroup -Name my-project -force