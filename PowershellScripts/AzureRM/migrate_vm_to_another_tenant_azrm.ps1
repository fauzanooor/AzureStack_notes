#### convert unmanaged to managed disk VM
ConvertTo-AzureRmVMManagedDisk -ResourceGroupName <resource-group-name> -VMName <vm-name>


### Convert managed to unmanaged disk VM
$vm = Get-AzureRmVM -ResourceGroupName <resource-group-name> -Name <vm-name>
$vm.StorageProfile.OsDisk | Where-Object {$_.ManagedDisk -ne $null} | Select-Object Name
$vm.StorageProfile.DataDisks | Where-Object {$_.ManagedDisk -ne $null} | Select-Object Name

Get-AzureRmStorageAccountKey -ResourceGroupName <resource-group-name> -Name <storage-account-name> | Select-Object Value
$context = New-AzureStorageContext -StorageAccountName <storage-account-name> -StorageAccountKey <storage-account-key>

$sas = Grant-AzureRmDiskAccess -ResourceGroupName <resource-group-name> -DiskName <osdisk-name> -Access Read -DurationInSecond (60*60*24)
$sasDataDisk = Grant-AzureRmDiskAccess -ResourceGroupName <resource-group-name> -DiskName <datadisk-name> -Access Read -DurationInSecond (60*60*24)

Set-AzureRmCurrentStorageAccount -StorageAccountName <storage-account-name> -ResourceGroupName <resource-group-name>
$containerName = "converted"
New-AzureStorageContainer -Name $containerName -Context $ctx -Permission blob

$blobcopyresult = Start-AzureStorageBlobCopy -AbsoluteUri $sas.AccessSAS -DestinationContainer "converted" -DestinationBlob "<osdis-name>.vhd" -DestinationContext $context
$blobcopyresult = Start-AzureStorageBlobCopy -AbsoluteUri $sasDataDisk.AccessSAS -DestinationContainer "converted" -DestinationBlob "<datadisk-name>.vhd" -DestinationContext $context
$blobcopyresult |  Get-AzureStorageBlobCopyState



### re-creating VM from copied VHD
$vmconfig = New-AzureRmVMConfig -VMName <vm-name> -VMSize "<size-of-the-vm>"
$vm = Add-AzureRmVMNetworkInterface -VM $vmConfig -Id (Get-AzureRmNetworkInterface -Name <nic-name> -ResourceGroupName <resource-group-name>).Id
$vm = Set-AzureRmVMBootDiagnostics -VM $vm -Enable -ResourceGroupName <resource-group-name> -StorageAccountName <storage-account-name>
$context = New-AzureStorageContext -StorageAccountName <storage-account-name> -StorageAccountKey "<storage-account-key>"
$vm = Set-AzureRmVMOSDisk -VM $vm -VhdUri (Get-AzureStorageBlob -Context $context -Blob "<osdisk-name>.vhd" -Container "vhd").ICloudBlob.uri.AbsoluteUri -CreateOption Attach -Name "<osdisk-name>" -Linux
#$vm = Set-AzureRmVMDataDisk -VM $vm -VhdUri (Get-AzureStorageBlob -Context $context -Blob "<datadisk-name>.vhd" -Container "vhd").ICloudBlob.uri.AbsoluteUri -CreateOption Attach -Name "<datadisk-name"
New-AzureRmVM -ResourceGroupName <resource-group-name> -Location <Location-name> -VM $vm



## copy vhd to another storage account
cd "C:\Program Files (x86)\Microsoft SDKs\Azure\AzCopy"
azcopy `
    /source:https://<source-storage-account>.azurestack.local/vhds/ `
    /Dest:https://<target-storage-account>.azurestack.local/vhds/ `
    /sourcekey:<source-storage-account-key> `
    /destkey:<target-storage-account-key> `
    /pattern:<vhd-name>.vhd