# set variables for file output - taken from Common Repairs Script
$fileoutPath = Split-Path $PSScriptRoot -Parent
$fileoutPath += "/DumpOutputs"
mkdir $fileoutPath -Force | Out-Null
$computerinformation = Get-ComputerInfo
$PCName = $computerinformation.CsName
$UserName = $computerinformation.CsUserName.Split("\")[1]
$TDStamp = Get-Date -UFormat %y%m%d%H%M%S
$filename = "$($fileoutPath)\$($PCName)--$($UserName)--$($TDStamp)--ModernApplications.txt"

Get-AppxPackage | Out-File $filename -Force