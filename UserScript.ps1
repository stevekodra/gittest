
Set-ExecutionPolicy Unrestricted -Force
Enable-PSRemoting -Force -SkipNetworkProfileCheck
New-Item -Path C:\ -Name Scripts -Type Directory 
$SorceforADScript = "https://raw.githubusercontent.com/stevekodra/gittest/testinggit/DeployAD.ps1"
$DowloadLocationTO = "C:\Scripts\DeployAD.ps1" 
$Download = Invoke-WebRequest $SorceforADScript -OutFile $DowloadLocationTO 
$sourceforinstanceScript = "https://raw.githubusercontent.com/stevekodra/gittest/testinggit/renameinstance.ps1"
$DownloadDestinationTO =  "C:\Scripts\renameinstance.ps1"
Invoke-WebRequest $sourceforinstanceScript -OutFile $DownloadDestinationTO 
$RuntheRenameScript = 'C:\Scripts\renameinstance.ps1' 
Invoke-Expression $RuntheRenameScript
