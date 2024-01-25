# NOTHING BELOW THIS LINE SHOULD NEED TO BE MODIFIED
# output should be ScriptDIR\PCName--UserName--TimeStamp.txt

# Below taken from https://blog.expta.com/2017/03/how-to-self-elevate-powershell-script.html
# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
 if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
  $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
  Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
  Exit
 }
}

# set variables for file output
$fileoutPath = Split-Path $PSScriptRoot -Parent
$fileoutPath += "/DumpOutputs"
mkdir $fileoutPath -Force | Out-Null
$computerinformation = Get-ComputerInfo
$PCName = $computerinformation.CsUserName.Split("\")[1]
$UserName = $computerinformation.OsRegisteredUser
$TDStamp = Get-Date -UFormat %y%m%d%H%M%S
$filename = "$($fileoutPath)\$($PCName)--$($UserName)--$($TDStamp).txt"
# output computer information
$computerinformation | Select-Object OsName, BiosFirmwareType, CsDomain, CsName, CsProcessors, OsArchitecture, OsRegisteredUser | Out-File -FilePath $filename
# output GPU configuration
Get-WmiObject Win32_VideoController | Select Name, VideoModeDescription | Out-File -Append -FilePath $filename
# output Network Information
Get-NetIPAddress -AddressFamily IPv4 | Select-Object InterfaceAlias, IPAddress, ValidLifetime | Out-File -Append -FilePath $filename

# variables for commands to be run
$confirmOpenFile = $false
$confirmCHKDSK = $false
$confirmDISM = $false
$confirmCleanup = $false


# ask if file needs to be opened
Write-Output "Output completed and stored in file: $filename"
Write-Output "Would you like to open the file? [Y/N]"
#below commands do NOT work in ISE because of command output redirection, thanks to the admin requirement it shouldn't be a problem unless the ISE is run under admin rights
$inputKey = [Console]::ReadKey()
$confirmOpenFile = ($inputKey.KeyChar -eq "y" -or $inputKey.KeyChar -eq "Y")
Write-Output ""

#Ask for CHKDSK
Write-Output "Would you like to run CHKDSK? [Y/N]"
$inputKey = [Console]::ReadKey()
$confirmCHKDSK = ($inputKey.KeyChar -eq "y" -or $inputKey.KeyChar -eq "Y")
Write-Output ""

#Ask for DISM
Write-Output "Would you like to run DISM? [Y/N]"
$inputKey = [Console]::ReadKey()
$confirmDISM = ($inputKey.KeyChar -eq "y" -or $inputKey.KeyChar -eq "Y")
Write-Output ""

#Ask for cleanmgr.exe
Write-Output "Would you like to run Disk Cleanup? [Y/N]"
$inputKey = [Console]::ReadKey()
$confirmCleanup = ($inputKey.KeyChar -eq "y" -or $inputKey.KeyChar -eq "Y")
Write-Output ""

# run commands based on inputs
if ($confirmOpenFile)
{
    Write-Output "Opening File..."
    notepad $filename
    Wait-Process notepad
}

if ($confirmCHKDSK)
{
    Write-Output "Checking Disk..."
    chkdsk /F
}

if ($confirmDISM)
{
    Write-Output "Checking Source Image..."
    DISM /Online /Cleanup-Image /RestoreHealth
}

if ($confirmCleanup)
{
    Write-Output "Running Cleanup Utility"
    cleanmgr.exe
    Wait-Process cleanmgr
}

Write-Output "Commands run as specified"

pause