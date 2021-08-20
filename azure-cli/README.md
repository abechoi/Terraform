<h1 align="center">
Azure CLI
</h1>
<p align="center">By Sanjeev Thiyagarajan</p>

1. [AZ Login](#az-login)
2. [AZ Configure](#az-configure)
3. [Resource Groups](#resource-groups)
4. [List and Show](#list-and-show)
5. [Virtual Machines](#virtual-machines)

## AZ Login

1. Login to Azure
```
az login
```

## AZ Configure

1. Configure default settings
```
# set RG-1 as default group
az configure --default group=RG-1
```

## Resource Groups

1. Create a resource group
```
# list locations
az account list-locations

# create resource group
az group create -l westus2 -n RG-2 
```

2. Delete a resource group
```
az group delete -n RG-2
```

## List and Show
1. List VMs
```
# show details for a VM
az vm show -g RG-2 -n az-vm 

# list all VMs
az vm list

# list available VM images
az vm image list

# list all resource groups
az group list
```

## Virtual Machines

1. Create a VM
```
# create a VM
az vm create -n az-vm -g RG-2 --image UbuntuLTS --authentication-type password --admin-username abe123
```

2. Modify a VM
```
# add tags to a VM
az vm update -g RG-2 -n az-vm --set tags.department=accounting tags.owner=abe
```

3. Stop and Deallocate a VM
```
# stop a VM
az vm stop -g RG-2 -n az-vm

# deallocate a VM
az vm deallocate -g RG-1 -n az-vm
```

4. Start a VM
```
# start by resource group and name
az vm start -g RG-1 -n test-VM

# start by id
az vm start --ids /subscriptions/e33f937c-8f7e-439f-8ffc-88a83dd4bf65/resourceGroups/RG-1/providers/Microsoft.Compute/disks/test-VM_OsDisk_1_08e2e53aaf3b411b81c978b9cd70dfb6
```

5. Delete a VM
```
az vm delete -g RG-1 -n test-VM
```