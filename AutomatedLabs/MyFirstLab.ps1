#Here AL installs a lab with one domain controller and one client. The OS can be configured quite easily as well as
#the domain name or memory. AL takes care about network settings like in the previous samples.
New-LabSourcesFolder

New-LabDefinition -name MyFirstLab -DefaultVirtualizationEngine HyperV

Get-LabAvailableOperatingSystem

$PSDefaultParameterValues = @{
    'Add-LabMachineDefinition:DomainName' = 'contoso.com'
    'Add-LabMachineDefinition:Memory'     = 1GB
}

# Our first machine
Add-LabMachineDefinition -Name DC1  -OperatingSystem 'Windows Server 2022 Datacenter Evaluation (Desktop Experience)' -Roles RootDC
Add-LabMachineDefinition -Name Client1  -OperatingSystem 'Windows 11 Pro' 

# Install the lab
Install-Lab

Show-LabDeploymentSummary

# RDP into the machine
Connect-LabVM -ComputerName MyFirstVm