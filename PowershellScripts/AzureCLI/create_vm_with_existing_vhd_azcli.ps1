## upload vhd
az storage blob upload --account-name <storage-account-name> --container-name <container-name> `
    --type page --file <path-to-vhd-file-from-local>.vhd `
    --name <name-of-vhd-file>.vhd

## check vhd uri
az storage blob url --account-name <storage-account-name> --container-name <container-name> `
    --name <name-of-vhd-file>.vhd

## create vm with uploaded vhd    
az vm create --resource-group <resource-group-name> --storage-account <storage-account-name> --location <location-name> `
    --name <vm-name> --vnet-name <vnet-name> --subnet <subnet-name> --nsg <nsg-name> `
    --size Basic_A2 --image "<existing-osdisk-uri>.vhd" `
    --attach-data-disks "<existing-osdisk-uri>.vhd" `
    --os-type linux --use-unmanaged-disk `
    --admin-username <username> --authentication-type password --admin-password <password>