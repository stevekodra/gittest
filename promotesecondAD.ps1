###########################################################
# AUTHOR  : Steve kodra
# DATE    : 25-05-2016 
# COMMENT : This script ADD a Second Server as part of Active Directory role
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
Import-Module International 

# ----Import 'International' module to Powershell session
Set-Culture en-GB

# ----Set regional format (date/time etc.) to English GB - this applies to all users lgoin in
Set-WinSystemLocale en-GB 

Set-WinHomeLocation -GeoId 242

# ----Set the language list for the user, forcing English (Australia) to be the only language
Set-WinUserLanguageList en-GB -Force


Add-WindowsFeature AD-Domain-Services

Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath 'C:\Windows\NTDS' -DomainMode 'Win2012' -DomainName 'Digitalday.LAB.net' -DomainNetbiosName 'Digital' -ForestMode 'Win2012' -InstallDns:$true -LogPath 'C:\Windows\NTDS' -NoRebootOnCompletion:$true -SysvolPath 'C:\Windows\SYSVOL' -Force:$true

#Set- the NTP On Domain Controller to UK Standart NTP servers as belo: 
w32tm.exe /config /manualpeerlist:”0.uk.pool.ntp.org 1.uk.pool.ntp.org 2.uk.pool.ntp.org 3.uk.pool.ntp.org” /syncfromflags:manual /reliable:YES /update
w32tm.exe /config /update
Restart-Service w32time

Remove-Item -Path "C:\Scripts\DpromotesecondAD.ps1" -Force -Recurse

Restart-Computer | Start-Sleep 3