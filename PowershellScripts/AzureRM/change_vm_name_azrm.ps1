#Prepare the VM variables
$rgName = "<resource-group-name>"
$location = "<location-name>"
$vnet = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/<resource-group-name>/providers/Microsoft.Network/virtualNetworks/<vnet-name>"
$subnet = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/<resource-group-name>/providers/Microsoft.Network/virtualNetworks/<vnet-name>/subnets/<subnet-name>"
$nicName = "<nic-existing-of-vm>"
$vmName = "<new-vm-name>"
$osDiskName = "<new-osdisk-name>"
$osDiskUri = "https://<storage-account-name>.blob.core.windows.net/vhd/<osdisk-vhd-name>.vhd"
$VMSize = "<size-of-the-vm>"
$storageAccountType = "StandardLRS"

#Create the VM resources
$IPconfig = New-AzureRmNetworkInterfaceIpConfig -Name "IPConfig1" -PrivateIpAddressVersion IPv4 -SubnetId $subnet
$nic = New-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $rgName -Location $location -IpConfiguration $IPconfig
$vmConfig = New-AzureRmVMConfig -VMName $vmName -VMSize $VMSize
$vm = Add-AzureRmVMNetworkInterface -VM $vmConfig -Id $nic.Id
$osDisk = New-AzureRmDisk -DiskName $osDiskName -Disk (New-AzureRmDiskConfig -AccountType $storageAccountType -Location $location -CreateOption Import -SourceUri $osDiskUri) -ResourceGroupName $rgName
$vm = Set-AzureRmVMOSDisk -VM $vm -ManagedDiskId $osDisk.Id -StorageAccountType $storageAccountType -DiskSizeInGB 128 -CreateOption Attach -Linux
$vm = Set-AzureRmVMBootDiagnostics -VM $vm -disable

#Create the new VM
New-AzureRmVM -ResourceGroupName $rgName -Location $location -VM $vm