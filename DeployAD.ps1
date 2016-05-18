###########################################################
# AUTHOR  : seve kodra
# DATE    : 25-02-2015 
# COMMENT : This script install Active Directory role
# VERSION : 1.0
###########################################################
#ERROR REPORTING ALL
#Rename-Computer AWSAD11 -restart
Set-ExecutionPolicy Unrestricted -Force
Set-StrictMode -Version latest


#Set an StaticIP to the server 


#Import PowerShell Module 
Try
{
Import-Module -Name ServerManager 
}
Catch
{
    Write-Host "[ERROR] Module couldn't be loaded. Script will stop!"
    Exit 1
}
#Install Windows Backup and SNMP Features
try
{
Install-WindowsFeature SNMP-Service, SNMP-WMI-Provider, Windows-Server-Backup -ErrorAction SilentlyContinue
}
Catch
{
    Write-Host "[ERROR] Couldn't be install feature. Script will stop!"
}
#Input Domain Name
$dcname = "Digitalday.LAB.net"
$netbios = "Digital"
$SecurePassword = "P@ssw0rd" | ConvertTo-SecureString -AsPlainText -Force
#Install AD-DS role
#Import-Module ADDSDeployment
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools -Verbose -ErrorAction SilentlyContinue
#Create forest and install ad dc,dns
Install-ADDSForest -domainname $dcname -DomainMode Win2012R2 -ForestMode Win2012R2  -InstallDns:$true -DomainNetbiosName $netbios -SafeModeAdministratorPassword $SecurePassword  -NoRebootOnCompletion:$false -Force
Rename-Computer AWSAD01 -restart