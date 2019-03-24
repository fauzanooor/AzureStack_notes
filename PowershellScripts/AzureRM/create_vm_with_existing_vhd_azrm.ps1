$rgname = '<storage-account-name>'
$loc = '<location-name>'
$vmsize = '<size-of-the-vm>'
$vmname = '<vm-name>'
$nic1 = '<existing-nic-name>'

Get-AzureRmSubscription –SubscriptionID "$subID" | Select-AzureRmSubscription
$vm = New-AzureRmVMConfig -VMName $vmname -VMSize $vmsize;
$nic1 = Get-AzureRmNetworkInterface -Name ($nic1) -ResourceGroupName $rgname;
$nic1Id = $nic1.Id;
$vm = Add-AzureRmVMNetworkInterface -VM $vm -Id $nic1Id;
$vm = Set-AzureRmVMOSDisk -CreateOption attach -Name PuhuiDevelopment-DB-01 -VhdUri 'https://<storage-account-name>.blob.azurestack.local/vhds/<osdisk-vhd-file>.vhd' -Linux -vm $vm
New-AzureRmVM -Location $loc -ResourceGroupName $rgname -VM $vm 