from azure.identity import AzureCliCredential
from azure.mgmt.resource import ResourceManagementClient
import csv

subscription_id = "233750e3-a3da-4a8b-bc2c-b1675731d161"
credentials = AzureCliCredential()

resource_client = ResourceManagementClient(credentials, subscription_id)


with open('Azureresourcegroups.csv') as file:
    resources = csv.reader(file,delimiter = ",")
    line_count = 0
    for resource in resources:
        if line_count == 0:
            line_count += 1
        resource_client.resource_groups.create_or_update(resource[0],{
            "location": resource[2]
            })
