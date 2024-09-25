New-LabDefinition -Name Lab0 -DefaultVirtualizationEngine HyperV

Add-LabVirtualNetworkDefinition -Name Lab0 -addressSpace 10.0.0.0/16
Add-LabVirtualNetworkDefinition -Name 'External' -HyperVProperties @{ SwitchType = 'External'; AdapterName = 'Ethernet 2' }

Add-LabMachineDefinition -Name DC1 -Memory 2GB -OperatingSystem 'Windows Server 2022 Datacenter Evaluation (Desktop Experience)' -Roles RootDC -Network Lab0 -DomainName contoso.com
Add-LabMachineDefinition -Name CA1 -Memory 2GB -OperatingSystem 'Windows Server 2022 Datacenter Evaluation (Desktop Experience)'-Roles CaRoot -Network Lab0 -DomainName contoso.com
Add-LabMachineDefinition -name SQL1 -Memory 2GB -OperatingSystem 'Windows Server 2022 Datacenter Evaluation (Desktop Experience)' -Network Lab0 -DomainName contoso.com

$netAdapter = @()
$netAdapter += New-LabNetworkAdapterDefinition -VirtualSwitch Lab0 -Ipv4Address 10.0.0.100
$netAdapter += New-LabNetworkAdapterDefinition -VirtualSwitch 'External' -UseDhcp
Add-LabMachineDefinition -Name Router1 -Memory 2GB -OperatingSystem 'Windows Server 2022 Datacenter Evaluation (Desktop Experience)' -Roles Routing -NetworkAdapter $netAdapter -DomainName contoso.com

Add-LabMachineDefinition -Name Client1 -Memory 2GB -Network Lab0 -OperatingSystem 'Windows 11 Pro' -DomainName contoso.com

Install-Lab

Show-LabDeploymentSummary -Detailed
