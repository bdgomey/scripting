import csv
from azure.identity import AzureCliCredential
from azure.mgmt.resource import ResourceManagementClient


subscription_id = "233750e3-a3da-4a8b-bc2c-b1675731d161"

credential = AzureCliCredential()
resource_client = ResourceManagementClient(credential, subscription_id)

with open(r'Azureresourcegroups.csv') as csvfile:
    resources = csv.reader(csvfile, delimiter = ",")
    line_count = 0
    for RESOURCE_GROUP_NAME in resources:
        if line_count == 0:
            line_count += 1        
        response = resource_client.resource_groups.begin_delete(RESOURCE_GROUP_NAME[0])
        response.wait()
        print(f"{RESOURCE_GROUP_NAME[0]} has been deleted")