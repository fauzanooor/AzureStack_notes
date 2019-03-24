## deploy vm with image from marketplace, for the format should be using URN
## check list URN image from marketplace
az vm image list --all

## create vm
az vm create --resource-group <resource-group-name> --storage-account <storage-account-name> --use-unmanaged-disk --location <location-name> `
    --name <vm-name> `
    --vnet-name <vnet-name> --subnet <subnet-name> `
    --nsg <nsg-name> `
    --size <size-of-the-vm> `
    --image "WindowsServer:2012-R2-Datacenter:4.127.20180815" ` ##URN
    --os-type windows `
    --admin-username <username> --authentication-type password --admin-password <password>