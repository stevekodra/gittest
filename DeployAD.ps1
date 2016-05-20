###########################################################
# AUTHOR  : Steve kodra
# DATE    : 25-02-2015 
# COMMENT : This script install Active Directory role
# VERSION : 1.0
###########################################################
#ERROR REPORTING ALL

# ----SET Pwershell to execute other powershell scripts

Set-ExecutionPolicy Unrestricted -Force

# ----SET restriction mode 

Set-StrictMode -Version latest

# ----SET TimeZONE to UK Time Zone

$timeZone = "GMT Standard Time"
$WinOSVerReg = Get-Item "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
$WinOSVer = $WinOSVerReg.GetValue("CurrentVersion")
if ($WinOSVer -GE 6){
tzutil.exe /s $timeZone
} Else {
$params = "/c Start `"Change timeZone`" /MIN %WINDIR%\System32\Control.exe TIMEDATE.CPL,,/Z "
$params += $timeZone
$proc = [System.Diagnostics.Process]::Start( "CMD.exe", $params )
}

# ----SET TimeZONE to UK Finished
# ----Script to configure language settings for each user

# ----Import 'International' module to Powershell session
Import-Module InternationalSet-Culture en-GB

# ----Set regional format (date/time etc.) to English GB - this applies to all users
Set-WinSystemLocale en-GB 
Set-WinHomeLocation -GeoId 242

# ----Set the language list for the user, forcing English (Australia) to be the only language
Set-WinUserLanguageList en-GB -Force


#-----Import PowerShell Module for Server Manager
Try
{
Import-Module -Name ServerManager 
}
Catch
{
    Write-Host "[ERROR] Module couldn't be loaded. Script will stop!"
    Exit 1
}
#-----Install Windows Backup and SNMP Features
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
Install-ADDSForest -domainname $dcname -DomainMode Win2012R2 -ForestMode Win2012R2  -InstallDns:$true -DomainNetbiosName $netbios -SafeModeAdministratorPassword $SecurePassword  -NoRebootOnCompletion:$true -Force
 
#Set- the NTP On Domain Controller to UK Standart NTP servers as belo: 
w32tm.exe /config /manualpeerlist:”0.uk.pool.ntp.org 1.uk.pool.ntp.org 2.uk.pool.ntp.org 3.uk.pool.ntp.org” /syncfromflags:manual /reliable:YES /update
w32tm.exe /config /update
Restart-Service w32time

Remove-Item -Path "C:\Scripts\DeployAD.ps1" -Force -Recurse

Restart-Computer | Start-Sleep 3



