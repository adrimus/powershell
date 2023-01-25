#Here AL installs a lab with one domain controller and one client. The OS can be configured quite easily as well as
#the domain name or memory. AL takes care about network settings like in the previous samples.
New-LabSourcesFolder

New-LabDefinition -name MyFirstLab -DefaultVirtualizationEngine HyperV

Get-LabAvailableOperatingSystem

# Our first machine
Add-LabMachineDefinition -Name DC1 -Memory 1GB -OperatingSystem 'Windows Server 2022 Datacenter Evaluation (Desktop Experience)' -Roles RootDC -DomainName contoso.com
Add-LabMachineDefinition -Name Client1 -Memory 1GB -OperatingSystem 'Windows 11 Enterprise Evaluation' -DomainName contoso.com

# Install the lab
Install-Lab

Show-LabDeploymentSummary

# RDP into the machine
Connect-LabVM -ComputerName MyFirstVm