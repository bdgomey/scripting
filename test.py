import csv
from azure.identity import AzureCliCredential
from azure.mgmt.resource import ResourceManagementClient

subscription_id = "233750e3-a3da-4a8b-bc2c-b1675731d161"
credential = AzureCliCredential()
resource_client = ResourceManagementClient(credential, subscription_id)

def scripting(csv_input):
    with open(csv_input) as file:
        data = csv.reader(file, delimiter = ",")
        line_count = 0
        for user in data:
            if line_count == 0:
                line_count += 1        
                    
            response = resource_client.resource_groups.begin_delete(user[0])        

scripting('Azureresourcegroups.csv')